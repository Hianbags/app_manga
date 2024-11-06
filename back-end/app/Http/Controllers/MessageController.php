<?php

namespace App\Http\Controllers;

use App\Events\GotMessage;
use App\Http\Controllers\API_BackEnd\Manga\Controller;
use App\Models\Message;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class MessageController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'receiver_id' => 'required|exists:users,id',
            'messages' => 'required|string',
        ]);

        $senderId = Auth::id();

        $message = Message::create([
            'sender_id' => $senderId,
            'receiver_id' => $request->receiver_id,
            'messages' => $request->messages,
        ]);

        broadcast(new GotMessage($message))->toOthers();

        return response()->json(['status' => 'Message Sent!']);
    }
}


