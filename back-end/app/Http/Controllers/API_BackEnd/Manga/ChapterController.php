<?php

namespace App\Http\Controllers\API_BackEnd\Manga;

use App\Models\Manga\Chapter;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;
use App\Http\Controllers\NotificationController;
use Illuminate\Support\Facades\Auth;

class ChapterController extends Controller
{
    protected $notificationController;

    public function __construct(NotificationController $notificationController)
    {
        $this->notificationController = $notificationController;
    }
    public function index($id)
    {
        $chapter = Chapter::where('manga_id', $id)->get();
        return response()->json([
            'status' => 'success',
            'data' => $chapter,
        ]);
    }
    public function send()
    {
        // kiểm tra xem đã xác thực người dùng chưa
        if (!Auth::check()) {
            return response()->json(['message' => 'chưa bé ơi '], 401);
        }
        $newChapterTitles[] = 'chapter1';
        $Manga_id = 2;

       $this->notificationController->sendNotification($newChapterTitles, $Manga_id);

        return response()->json(['message' => 'Notification sent successfully.']);
    }
    public function show($id)
    {
        try{
            $chapter = Chapter::findOrFail($id);
        if (empty($chapter)) {
            return response()->json([
                'status' => 'error',
                'message' => 'Chapter not found',
            ], 404);
        }
        return response()->json([
            'status' => 'success',
            'data' => $chapter,
        ]);
        }catch(\Exception $e){
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
public function store(Request $request)
{
    $Manga_id = $request->input('manga_id');
    $manga = DB::table('mangas')->where('id', $Manga_id)->first();
    if (!$manga) {
        return response()->json(['message' => 'Manga not found'], 404);
    }

    $zipFile = $request->file('zip_file');

    // Kiểm tra xem tệp tin zip đã được tải lên hay không
    if (!$zipFile) {
        return response()->json(['message' => 'ZIP file not found'], 400);
    }

    $zipPath = $zipFile->store('temp');

    // Kiểm tra xem tệp tin zip có thể mở được không
    $zip = new \ZipArchive;
    if ($zip->open(storage_path("app/$zipPath")) === TRUE) {
        $extractPath = storage_path('app/temp/' . $Manga_id);
        $zip->extractTo($extractPath);
        $zip->close();
        $chapters = scandir($extractPath);

        $newChapterTitles = []; // Danh sách tiêu đề chương mới

        foreach ($chapters as $chapter) {
            if ($chapter != '.' && $chapter != '..') {
                $chapterTitle = $chapter; 
                $newChapterTitles[] = $chapterTitle; 

                $chapterId = DB::table('chapters')->insertGetId([
                    'manga_id' => $Manga_id,
                    'title' => $chapterTitle,
                    'content' => null, 
                ]);
                $images = scandir("$extractPath/$chapter");
                foreach ($images as $image) {
                    if ($image != '.' && $image != '..') {
                        $filePath = "$extractPath/$chapter/$image";
                        if (is_file($filePath)) { // Kiểm tra nếu $filePath là một tệp tin
                            $fileName = time() . '_' . $image;
                            $fileContents = file_get_contents($filePath);
                            Storage::disk('public')->put("manga/$Manga_id/$chapter/$fileName", $fileContents);
                            DB::table('pages')->insert([
                                'chapter_id' => $chapterId,
                                'image' => "/storage/manga/$Manga_id/$chapter/$fileName",
                            ]);
                        }
                    }
                }
            }
        }
        File::delete(storage_path("app/$zipPath"));
        File::deleteDirectory($extractPath);
        $this->notificationController->sendNotification($newChapterTitles, $Manga_id);

        return response()->json(['success'=> true,'message' => 'Story imported successfully'], 200);
    } else {
        return response()->json(['message' => 'Failed to extract ZIP file'], 500);
    }
}
    public function destroy(Request $request)
{
    $chapterId = $request->input('chapter_id');
    $chapter = DB::table('chapters')->where('id', $chapterId)->first();

    if (!$chapter) {
        return response()->json(['message' => 'Chapter not found'], 404);
    }
    // Lấy danh sách các trang (pages) của chương
    $pages = DB::table('pages')->where('chapter_id', $chapterId)->get();

    // Xóa các tệp tin hình ảnh của các trang
    foreach ($pages as $page) {
        $imagePath = public_path($page->image); // Lấy đường dẫn tệp tin hình ảnh
        if (file_exists($imagePath)) {
            unlink($imagePath); // Xóa tệp tin
        }
    }

    // Xóa các trang từ cơ sở dữ liệu
    DB::table('pages')->where('chapter_id', $chapterId)->delete();

    // Xóa chương từ cơ sở dữ liệu
    DB::table('chapters')->where('id', $chapterId)->delete();

    return response()->json(['success' => true, 'message' => 'Chapter deleted successfully'], 200);
}


}
