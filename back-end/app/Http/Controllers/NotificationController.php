<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\API_BackEnd\Manga\Controller;

class NotificationController extends Controller
{
    protected $firebaseService;

    public function __construct(FirebaseService $firebaseService)
    {
        $this->firebaseService = $firebaseService;
    }

    public function sendNotification($newChapterTitles, $Manga_id)
    {
        
        $userFV = DB::table('favorites')->where('manga_id', $Manga_id)->get();
        foreach ($userFV as $fv) {
            $deviceTokens = DB::table('device_tokens')->where('user_id', $fv->user_id)->pluck('device_token');
            foreach ($deviceTokens as $deviceToken) {
                $title = DB::table('mangas')->where('id', $Manga_id)->value('title');
                $body = 'Chương mới cập nhật: ' . implode(', ', $newChapterTitles);
                $data = [
                    'manga_id' => $Manga_id,
                    'new_chapters' => $newChapterTitles,
                ];
                try {
                    $this->firebaseService->sendNotification($deviceToken, $title, $body, $data);
                } catch (\Kreait\Firebase\Exception\Messaging\NotFound $e) {
                    // Xử lý khi token không hợp lệ
                    DB::table('device_tokens')->where('device_token', $deviceToken)->delete();
                } catch (\Exception $e) {
                    // Xử lý các lỗi khác
                    error_log('Failed to send notification: ' . $e->getMessage());
                }
            }
        }
        return response()->json(['message' => 'Notification sent successfully.']);
    }
}
