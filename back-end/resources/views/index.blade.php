<!DOCTYPE html>
<html>
<head>
    <title>WebSocket Test</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pusher/7.0.3/pusher.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        Pusher.logToConsole = true;

        var pusher = new Pusher('kxrux1shjl6iusl1krst', {
            cluster: 'mt1',
            wsHost: 'localhost',
            wsPort: 9000,
            wssPort: 9000,
            forceTLS: false,
            encrypted: false,
            enabledTransports: ['ws', 'wss']
        });
        var user1 = {{ Auth::id() }};
        var user2 = prompt("Nhập ID của người dùng bạn muốn trò chuyện:");

        var channelName = 'chat.' + Math.min(user1, user2) + '.' + Math.max(user1, user2);

        var channel = pusher.subscribe(channelName);
        channel.bind('App\\Events\\GotMessage', function(data) {
            console.log("Tin nhắn nhận được:", data);
            $('#messages').append('<p>' + data.message.sender_id + ': ' + data.message.messages + '</p>');
        });
        channel.bind('pusher:subscription_succeeded', function() {
            console.log('Đăng ký thành công vào kênh ' + channelName);
        });

        $(document).ready(function() {
            $('#sendMessageForm').submit(function(e) {
                e.preventDefault();
                var messageText = $('#messageText').val();

                $.ajax({
                    url: '/send-message',
                    type: 'POST',
                    data: {
                        receiver_id: user2,
                        messages: messageText,
                        _token: '{{ csrf_token() }}'
                    },
                    success: function(response) {
                        console.log('Tin nhắn đã gửi:', response);
                        $('#messages').append('<p>Bạn: ' + messageText + '</p>');
                        $('#messageText').val('');
                    }
                });
            });
        });
    </script>
</head>
<body>
    <h1>Kiểm tra WebSocket</h1>
    <div id="messages">
        <p>Kiểm tra console để xem tin nhắn</p>
    </div>
    <form id="sendMessageForm">
        <input type="text" id="messageText" placeholder="Nhập tin nhắn của bạn" required>
        <button type="submit">Gửi</button>
    </form>
</body>
</html>
