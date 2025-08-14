using RabbitMQ.Client;
using System.Text;
using System.Text.Json;
using eServisnaKnjiga.Model;

public static class SmsPublisher
{
    public static void SendSms(SmsMessage smsMessage)
    {
        var factory = new ConnectionFactory
        {
            HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost",
            Port = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT") ?? "5672"),
            UserName = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest",
            Password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest",
        };

        using var connection = factory.CreateConnection();
        using var channel = connection.CreateModel();

        string queueName = "sms_queue";

        channel.QueueDeclare(queue: queueName,
                             durable: false,
                             exclusive: false,
                             autoDelete: false,
                             arguments: null);

        var messageJson = JsonSerializer.Serialize(smsMessage);
        var body = Encoding.UTF8.GetBytes(messageJson);

        channel.BasicPublish(exchange: "",
                             routingKey: queueName,
                             basicProperties: null,
                             body: body);

        Console.WriteLine("SMS message sent to sms_queue.");
    }
}
