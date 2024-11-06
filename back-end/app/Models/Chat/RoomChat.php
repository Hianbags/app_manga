<?php

namespace App\Models\Chat;
use Illuminate\Database\Eloquent\Model;


class RoomChat extends Model
{
    protected $table = 'room_chats';

    protected $fillable = [
        'name',
        'description',
    ];
}