<?php

namespace App\Models\Manga;
use Illuminate\Database\Eloquent\Model;


class Manga extends Model
{
    protected $table = 'mangas';

    protected $primaryKey = 'id';

    protected $fillable = [
        'image',
        'title',
        'author',
        'description',
        'status',
        'rating',
        'views',
    ];
    public function categories()
    {
        return $this->belongsToMany(Category::class, 'manga_categories', 'manga_id', 'category_id');
    }
}