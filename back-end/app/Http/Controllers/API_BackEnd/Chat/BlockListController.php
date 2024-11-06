<?php
namespace App\Http\Controllers\API_BackEnd\Chat;

use App\Http\Controllers\API_BackEnd\Manga\Controller;
use App\Models\Chat\BlockList;
use Illuminate\Http\Request;

class BlockListController extends Controller
{
    public function blockUser(Request $request)
    {
        $block = BlockList::create([
            'user_id' => $request->user()->id,
            'blocked_user_id' => $request->blocked_user_id,
        ]);

        return response()->json($block, 201);
    }

    public function unblockUser(Request $request)
    {
        BlockList::where('user_id', $request->user()->id)
                ->where('blocked_user_id', $request->blocked_user_id)
                ->delete();
        return response()->json(null, 204);
    }

    public function isBlocked($blocked_user_id)
    {
        $isBlocked = BlockList::where('user_id', auth()->user()->id)
                        ->where('blocked_user_id', $blocked_user_id)
                        ->exists();
        return response()->json(['is_blocked' => $isBlocked]);
    }
}
