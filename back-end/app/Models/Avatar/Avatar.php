<?php

namespace App\Models\Avatar;
use Illuminate\Database\Eloquent\Model;


class Avatar extends Model
{
    protected $table = 'avatars';
    protected $fillable = [
        'image',
    ];

}