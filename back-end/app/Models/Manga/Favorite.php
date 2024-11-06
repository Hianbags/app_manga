<?php

namespace App\Models\Manga;

use App\Models\User;
use Illuminate\Database\Eloquent\Model;

class Favorite extends Model
{
    protected $table = 'favorites';

    protected $fillable = [
        'user_id',
        'manga_id',
    ];

    protected $casts = [
        'user_id' => 'integer',
        'manga_id' => 'integer',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function manga()
    {
        return $this->belongsTo(Manga::class);
    }
}