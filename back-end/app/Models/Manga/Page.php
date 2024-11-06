<?php

namespace App\Models\Manga;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Page extends Model
{
    use HasFactory;
    protected $fillable = [
        'chapter_id',
        'image',
    ];
    
}
