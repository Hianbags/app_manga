<?php

namespace App\Http\Controllers;

use App\Http\Controllers\API_BackEnd\Manga\Controller;
use App\Models\DeviceToken;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class DeviceTokenController extends Controller
{
    public function saveToken(Request $request)
    {
        $request->validate([
            'device_token' => 'required|string',
        ]);
        $user = Auth::guard('api')->user();
        $user_id = $user ? $user->id : null;
        DeviceToken::updateOrCreate(
            ['device_token' => $request->device_token],
            ['user_id' => $user_id]
        );
        return response()->json(['success' => true]);
    }
}