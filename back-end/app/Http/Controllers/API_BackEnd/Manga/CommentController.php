<?php

namespace App\Http\Controllers\API_BackEnd\Manga;

use App\Http\Resources\CommentCollectionResource;
use App\Models\Manga\Comment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CommentController extends Controller
{


    public function store(Request $request)
    {
        $this->validate($request, [
            'manga_id' => 'required|exists:mangas,id',
            'content' => 'required|string',
        ]);
        try {
            $user = Auth::user();
            $manga_id = $request->input('manga_id');
            $content = $request->input('content');
            $comment = Comment::create([
                'user_id' => $user->id,
                'manga_id' => $manga_id,
                'content' => $content,
            ]);
            return response()->json([
                'status' => 'success',
                'data' => $comment,
                'message' => 'Comment created successfully',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
    public function show($manga_id)
    {
        try {
            $comments = Comment::where('manga_id', $manga_id)->paginate(10);
            return new CommentCollectionResource($comments);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
    
    public function update(Request $request, $id)
    {
        $comment = Comment::findOrFail($id);
        $comment->content = $request->input('content');
        $comment->save();
        return response()->json([
            'status' => 'success',
            'data' => $comment,
        ]);
    }
    public function destroy($id)
    {
        $comment = Comment::findOrFail($id);
        $comment->delete();
        return response()->json([
            'status' => 'success',
            'message' => 'Comment deleted',
        ]);
    }
}