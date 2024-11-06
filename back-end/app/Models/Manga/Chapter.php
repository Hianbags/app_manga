<?php

namespace App\Models\Manga;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Chapter extends Model
{
    use HasFactory;

    protected $table = 'chapters';

    protected $primaryKey = 'id';

    protected $fillable = [
        'manga_id',
        'title',
        'content',
        'views',
    ];
}
