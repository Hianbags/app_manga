<?php

namespace App\Http\Controllers\API_BackEnd\Chat;

use App\Http\Controllers\API_BackEnd\Manga\Controller;
use App\Models\Chat\RoomChat;
use Illuminate\Http\Request;


class RoomChatController extends Controller
{
    public function index()
    {
        try {
            $roomchats = RoomChat::all();
            return response()->json([
                'status' => 'success',
                'data' => $roomchats,
            ]);
        }
        catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
    public function store(Request $request)
    {
        $room = RoomChat::create([
            'name' => $request->name,
            'description' => $request->description,
        ]);
        return response()->json($room, 201);
    }
}