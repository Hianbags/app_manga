<?php
namespace App\Models\Chat;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BlockList extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'blocked_user_id',
    ];
}
