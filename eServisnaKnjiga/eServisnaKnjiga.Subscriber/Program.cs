// See https://aka.ms/new-console-template for more information
using EasyNetQ;
using eServisnaKnjiga.Model;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;

Console.WriteLine("Hello, World!");
/*
var factory = new ConnectionFactory { HostName = "localhost" };
using var connection = factory.CreateConnection();
using var channel = connection.CreateModel();

channel.QueueDeclare(queue: "hello",
                     durable: false,
                     exclusive: false,
                     autoDelete: false,
                     arguments: null);

Console.WriteLine(" [*] Waithing for massages.");

var consumer = new EventingBasicConsumer(channel);
consumer.Received += (model, ea) =>
{
    var body = ea.Body.ToArray();
    var massage = Encoding.UTF8.GetString(body);
    Console.WriteLine($" [x] Received {massage}");
};

channel.BasicConsume(queue:"hello",
                     autoAck: true,
                     consumer: consumer);

Console.WriteLine(" Press [enter] to exit.");
Console.ReadLine();
*/

using (var bus = RabbitHutch.CreateBus("host=localhost"))
{
    bus.PubSub.Subscribe<eServisnaKnjiga.Model.Rezervacije>("test", HandleTextMassage);
    Console.WriteLine("Listening for massages. Hit <return> to quit.");
    Console.ReadLine();
}

void HandleTextMassage(Rezervacije entity)
{
    Console.WriteLine($"Recived: {entity?.Datum}");
}