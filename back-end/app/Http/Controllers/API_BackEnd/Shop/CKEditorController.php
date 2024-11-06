<?php
namespace App\Http\Controllers\API_BackEnd\Shop;

use App\Http\Controllers\API_BackEnd\Manga\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class CKEditorController extends Controller
{
    public function upload(Request $request)
    {
        try {
            if ($request->hasFile('upload')) {
                $file = $request->file('upload')->getClientOriginalName();
                $filename = pathinfo($file, PATHINFO_FILENAME);
                $extension = $request->file('upload')->getClientOriginalExtension();

                $filenameToStore = $filename . '_' . time() . '.' . $extension;

                $request->file('upload')->move(public_path('images/product_image'), $filenameToStore);
            
                $url = url('images/product_image/' . $filenameToStore);
                return response()->json([
                    'uploaded' => 1,
                    'fileName' => $filenameToStore,
                    'url' => $url,
                ]);
            }
        } catch (\Exception $e) {
            return response()->json([
                'uploaded' => 0,
                'error' => [
                    'message' => $e->getMessage(),
                ],
            ]);
        }
    }  
}
