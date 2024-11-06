<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\DB;

class UserResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'avatar' => 'https://magiabaiser.id.vn'.DB::table('users')
                ->join('users_avatars', 'users.id', '=', 'users_avatars.user_id')
                ->join('avatars', 'users_avatars.avatar_id', '=', 'avatars.id')
                ->select('avatars.image')
                ->where('users.id', $this->id)
                ->first()->image ?? 'https://magiabaiser.id.vn/storage/avatars/avatar_1717778746.jpg'
        ];
    }
}
