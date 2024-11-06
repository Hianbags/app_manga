<?php

namespace App\Http\Controllers\API_BackEnd\Manga;

use App\Http\Resources\PageCollectionResource;
use App\Models\Manga\Page;
use Illuminate\Support\Facades\DB;

class PageController extends Controller
{
    public function show($chapter_id)
    {
        try{
            $page = Page::where('chapter_id', $chapter_id)->get();
            $chapter = DB::table('chapters')->where('id', $chapter_id)->first();
            DB::table('mangas')->where('id', $chapter->manga_id)->increment('views');
            return $this->sendResponse(PageCollectionResource::collection($page), 'Page retrieved successfully.');
        }catch(\Exception $e){
            return $this->sendError($e->getMessage());
        }
    }
    
}
