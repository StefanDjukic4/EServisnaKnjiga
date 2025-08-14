using eServisnaKnjiga.Model;
using Newtonsoft.Json;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;
using Vonage;
using Vonage.Request;

Console.WriteLine("Waiting for RabbitMQ...");
await Task.Delay(10000);
Console.WriteLine("RabbitMQ should be ready.");

var factory = new ConnectionFactory()
{
    HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost",
    Port = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT") ?? "5672"),
    UserName = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest",
    Password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest",
};

var connection = factory.CreateConnection();
var channel = connection.CreateModel();

string queueName = "sms_queue";

channel.QueueDeclare(queue: queueName,
                     durable: false,
                     exclusive: false,
                     autoDelete: false,
                     arguments: null);

var consumer = new EventingBasicConsumer(channel);
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

channel.BasicConsume(queue: queueName, autoAck: true, consumer: consumer);

Console.WriteLine("Listening for SMS messages. Press Enter to exit.");
Console.ReadLine();

