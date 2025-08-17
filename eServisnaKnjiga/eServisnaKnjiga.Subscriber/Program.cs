using System.Text;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Newtonsoft.Json;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using Vonage;
using Vonage.Request;
using eServisnaKnjiga.Model;

public class Program
{
    public static async Task Main(string[] args)
    {
        await Host.CreateDefaultBuilder(args)
            .ConfigureServices((hostContext, services) =>
            {
                services.AddHostedService<RabbitMqWorker>();
            })
            .RunConsoleAsync();
    }
}

public class RabbitMqWorker : BackgroundService
{
    private IConnection _connection;
    private IModel _channel;

    protected override Task ExecuteAsync(CancellationToken stoppingToken)
    {
        Console.WriteLine("Waiting for RabbitMQ...");
        Task.Delay(10000, stoppingToken).Wait(stoppingToken);
        Console.WriteLine("RabbitMQ should be ready.");

        var factory = new ConnectionFactory()
        {
            HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost",
            Port = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT") ?? "5672"),
            UserName = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest",
            Password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest",
            DispatchConsumersAsync = true
        };

        _connection = factory.CreateConnection();
        _channel = _connection.CreateModel();

        string queueName = "sms_queue";
        _channel.QueueDeclare(queue: queueName,
                             durable: false,
                             exclusive: false,
                             autoDelete: false,
                             arguments: null);

        var consumer = new AsyncEventingBasicConsumer(_channel);
        consumer.Received += async (sender, args) =>
        {
            var body = args.Body.ToArray();
            string message = Encoding.UTF8.GetString(body);

            Console.WriteLine($"Received SMS message: {message}");

            var smsMessage = JsonConvert.DeserializeObject<SmsMessage>(message);

            var credentials = Credentials.FromApiKeyAndSecret(
                Environment.GetEnvironmentVariable("VONAGE_API_KEY") ?? "096bbb73",
                Environment.GetEnvironmentVariable("VONAGE_API_SECRET") ?? "uhKhAXM4YXocfmEQ"
            );

            var vonageClient = new VonageClient(credentials);

            var response = await vonageClient.SmsClient.SendAnSmsAsync(new Vonage.Messaging.SendSmsRequest
            {
                To = smsMessage.PhoneNumber,
                From = "E-Servisna Knjiga",
                Text = smsMessage.Text
            });

            Console.WriteLine("SMS sent via Vonage.");
        };

        _channel.BasicConsume(queue: queueName, autoAck: true, consumer: consumer);

        Console.WriteLine("Listening for SMS messages...");

        return Task.CompletedTask;
    }

    public override Task StopAsync(CancellationToken cancellationToken)
    {
        _channel?.Close();
        _connection?.Close();
        Console.WriteLine("RabbitMQ consumer stopped.");
        return base.StopAsync(cancellationToken);
    }
}
