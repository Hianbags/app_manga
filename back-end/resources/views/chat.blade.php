<!-- resources/views/chat.blade.php -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Chat</title>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const chatBox = document.getElementById('chat-box');
            const messageInput = document.getElementById('message-input');
            const sendButton = document.getElementById('send-button');
            const receiverId = document.getElementById('receiver-id').value;
            const lastId = 0;

            // Establish SSE connection
            if (window.EventSource) {
                const eventSource = new EventSource('/messages/stream');

                eventSource.onmessage = function(e) {
                    const messageData = JSON.parse(e.data);
                    const messageElement = document.createElement('div');
                    messageElement.innerText = `User ${messageData.sender_id}: ${messageData.message}`;
                    chatBox.appendChild(messageElement);
                };
            } else {
                alert("Your browser does not support SSE.");
            }

            // Send message via AJAX
            sendButton.addEventListener('click', function() {
                const message = messageInput.value;
                if (message) {
                    fetch('/messages', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                        },
                        body: JSON.stringify({
                            receiver_id: receiverId,
                            message: message
                        })
                    }).then(response => response.json()).then(data => {
                        messageInput.value = '';
                    }).catch(error => console.error('Error:', error));
                }
            });
        });
    </script>
</head>
<body>
    <h1>Chat</h1>
    <div id="chat-box" style="border: 1px solid #ccc; height: 300px; overflow-y: scroll;">
        <!-- Messages will appear here -->
    </div>
    <input type="hidden" id="receiver-id" value="{{ $receiverId }}">
    <input type="text" id="message-input" placeholder="Type your message here...">
    <button id="send-button">Send</button>
</body>
</html>
