using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VkNet;
using System.Data.SqlClient;
using System.Threading;

namespace KarmaVK
{
    class KarmaVKbot
    { 
        public KarmaVKbot(string accesToken)
        {
            //Data init
            chatIDs = new List<int>();
            //Connect to VK
            VKConnection = new VkApi();
            ApiAuthParams authParams = new ApiAuthParams();
            authParams.AccessToken = accesToken;
            VKConnection.Authorize(authParams);
            //Connection to DB
            using (SqlConnection db = new SqlConnection("User ID=KarmaVKUser;Password=123456;Initial Catalog=KarmaVKdb;Data Source=URANIUM\\SQLEXPRESS;"))
            {
                db.Open();
                string query = "SELECT DISTINCT chatId FROM Users";
                SqlCommand command = new SqlCommand(query, db);
                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read()) 
                    chatIDs.Add(reader.GetInt32(0));
                    /*ParameterizedThreadStart param = new par;
                    
                    Thread poller = new Thread(new ParameterizedThreadStart(serverPolling, chatIDs.Last())); */                  
                    serverPolling(82);
                
            }
            
        }

        public void Invalidate() { }

        public void serverPolling(int chatId)
        {
            long lastMsgId = (long)VKConnection.Messages.GetHistory(new VkNet.Model.RequestParams.MessagesGetHistoryParams { Count = 1, PeerId = chatId + 2000000000 }).Messages[0].Id;
            Console.WriteLine("Start polling");
            while (true)
            {
                var response = VKConnection.Messages.GetHistory(new VkNet.Model.RequestParams.MessagesGetHistoryParams { Count = 20, PeerId = chatId + 2000000000 });
                              
                if (response.Messages[0].Id > lastMsgId)
                {
                    for (int i = 0; i < response.Messages.Count; ++i)
                    {
                        if (response.Messages[i].Id > lastMsgId)
                        {
                            string msgbody = response.Messages[i].Body;
                            if (msgbody.Contains("/Karma"))
                            {
                                if (msgbody.Contains("stat"))
                                {
                                    using (SqlConnection db = new SqlConnection("User ID=KarmaVKUser;Password=123456;Initial Catalog=KarmaVKdb;Data Source=URANIUM\\SQLEXPRESS;"))
                                    {
                                        db.Open();
                                        string query = "EXEC getStat @conferenceID = " + chatId;
                                        SqlCommand command = new SqlCommand(query, db);
                                        var reader = command.ExecuteReader();
                                        string message = "Статистика кармы:";
                                        while (reader.Read())
                                        {
                                            var user = VKConnection.Users.Get(reader.GetInt32(0));
                                            message += "\n" + user.FirstName + " " + user.LastName + ": " + reader.GetSqlMoney(1) + " кармы";
                                        }
                                        var aa = new List<long>();
                                        aa.Add((long)response.Messages[i].Id);
                                        VKConnection.Messages.Send(new VkNet.Model.RequestParams.MessagesSendParams { ChatId = chatId, Message = message, ForwardMessages = aa });
                                    }
                                    continue;
                                }
                                try
                                {
                                    string recieverId = msgbody.Substring(msgbody.IndexOf("["), msgbody.IndexOf("|") - msgbody.IndexOf("[")).Substring(3);
                                    //Console.WriteLine(msgbody.Substring(msgbody.IndexOf("["), msgbody.IndexOf("|") - msgbody.IndexOf("[")).Substring(3));
                                    using (SqlConnection db = new SqlConnection("User ID=KarmaVKUser;Password=123456;Initial Catalog=KarmaVKdb;Data Source=URANIUM\\SQLEXPRESS;"))
                                    {
                                        db.Open();
                                        string query = "EXEC changeKarma @conferenceID = " + chatId + ", @transmitterVKID =  "+ response.Messages[i].FromId + ", @recieverVKID = " + recieverId + ", @transferAmount = 1";
                                        SqlCommand command = new SqlCommand(query, db);
                                        command.ExecuteReader();
                                    }
                                    var reciever = VKConnection.Users.Get(recieverId, null, VkNet.Enums.SafetyEnums.NameCase.Gen);
                                    var aa = new List<long>();
                                    aa.Add((long)response.Messages[i].Id);
                                    VKConnection.Messages.Send(new VkNet.Model.RequestParams.MessagesSendParams { ChatId = chatId, Message = "Ваш голос учтен в пользу " + reciever.FirstName + " " + reciever.LastName, ForwardMessages = aa });
                                }
                                catch
                                {
                                    var aa = new List<long>();
                                    aa.Add((long)response.Messages[i].Id);
                                    VKConnection.Messages.Send(new VkNet.Model.RequestParams.MessagesSendParams { ChatId = chatId, Message = "Команда не распознана", ForwardMessages = aa });
                                }
                            }
                        }
                    }
                    lastMsgId = (long)response.Messages[0].Id;
                }
                Thread.Sleep(200);
            }
        }

        private VkApi VKConnection;
        private List<int> chatIDs;
        private List<Thread> pollers;
    }
}
