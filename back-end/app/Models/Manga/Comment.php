<?php
namespace App\Models\Manga;

use App\Models\User;
use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    protected $fillable = [
        'user_id', 'manga_id', 'content',
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
