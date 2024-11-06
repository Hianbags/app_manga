<?php

use App\Events\GotMessage;
use App\Http\Controllers\API_BackEnd\Chat\BlockListController;
use App\Http\Controllers\API_BackEnd\Chat\RoomChatController;
use App\Http\Controllers\API_BackEnd\Manga\CategoryController;
use App\Http\Controllers\API_BackEnd\Manga\ChapterController;
use App\Http\Controllers\API_BackEnd\Manga\MangaController;
use App\Http\Controllers\API_BackEnd\Manga\PageController;
use App\Http\Controllers\API_BackEnd\Shop\OrderController;
use App\Http\Controllers\API_BackEnd\Shop\ProductController;
use App\Http\Controllers\API_BackEnd\User\UserController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\API_BackEnd\Manga\CommentController;
use App\Http\Controllers\DeviceTokenController;
use App\Models\Shop\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API_BackEnd\Manga\FavoriteController;
use App\Http\Controllers\API_BackEnd\Manga\RatingController;
use App\Http\Controllers\API_BackEnd\Shop\PaymentController;
use App\Http\Controllers\API_BackEnd\Shop\ShippingAddressController;
use App\Http\Controllers\API_BackEnd\Shop\ProductCategoryController;
use App\Http\Controllers\ChatsController;
use App\Http\Controllers\MessageController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return $request->user();
// });
Route::middleware('auth:api')->group(function () {
    Route::get('/details', [UserController::class, 'details']);
    Route::post('/logout', [UserController::class, 'logout']);
    Route::post('/order', [OrderController::class, 'store']);
    Route::get('/order', [OrderController::class, 'index']);
    Route::get('/order/{id}', [OrderController::class, 'show']);
    Route::get('/favorite', [FavoriteController::class, 'index']);
    Route::post('/favorite', [FavoriteController::class, 'store']);
    Route::post('/test/send', [ChapterController::class, 'send']);
    Route::post('/comment', [CommentController::class, 'store']);
    Route::post('/shipping-address', [ShippingAddressController::class, 'store']);
    Route::get('/shipping-address', [ShippingAddressController::class, 'index']);
    Route::put('/avatar', [UserController::class, 'update']);
    Route::post('/send-message', [MessageController::class, 'store']);
    Route::get('communications', [ChatsController::class, 'index'])->middleware(['auth', 'verified']);
    Route::post('block', [BlockListController::class, 'blockUser']);
    Route::post('unblock', [BlockListController::class, 'unblockUser']);
    Route::get('is_blocked/{blocked_user_id}', [BlockListController::class, 'isBlocked']);
    //rating
    Route::post('/rating/{id}', [RatingController::class, 'store']);

});
//router for manga
Route::get('/manga', [MangaController::class, 'index']);
Route::get('/manga-admin', [MangaController::class, 'indexAdmin']);
Route::get('/manga/{id}', [MangaController::class, 'show']);
Route::delete('/manga/{id}', [MangaController::class, 'destroy']);
Route::post('/manga/{id}', [MangaController::class, 'update']);


Route::get('/mostview', [MangaController::class, 'sortview']);

Route::get('/manga/mostViewByTime/{time}', [MangaController::class, 'mostViewByTime']);
Route::post('/manga', [MangaController::class, 'store']);

Route::get('/manga/{id}/chapter', [MangaController::class, 'chapter']);
//router for chapter
Route::get('/chapter/{id}', [ChapterController::class, 'index']);
Route::get('/search', [MangaController::class, 'search']);

//categories
Route::get('/category', [CategoryController::class, 'index']);
Route::get('/category/{id}', [CategoryController::class, 'show']);
Route::post('/category', [CategoryController::class, 'store']);


//pages
Route::get('/chapter/{id}/page', [PageController::class, 'show']);

//login
Route::post('/login', [UserController::class, 'login']);
Route::post('/register', [UserController::class, 'register']);

//chapter routes
Route::post('/chapter', [ChapterController::class, 'store']);
Route::delete('/chapter', [ChapterController::class, 'destroy']);

//product routes
Route::get('/product', [ProductController::class, 'index']);
Route::post('/products/store', [ProductController::class, 'store'])->name('products.store');
Route::get('/product/{id}', [ProductController::class, 'show']);
Route::delete('/product/{id}', [ProductController::class, 'destroy']);



 //order routes
Route::get('/listorder', [OrderController::class, 'order']);
Route::put('/order/{id}', [OrderController::class, 'update']);

Route::get('/product-category', [ProductCategoryController::class, 'index']);
Route::get('/product-category/{id}', [ProductCategoryController::class, 'show']);

Route::post('/send-notification', [NotificationController::class, 'sendNotification']);
Route::post('/save-token', [DeviceTokenController::class, 'saveToken']);

Route::get('/comment/{manga_id}', [CommentController::class, 'show']);

Route::get('/getProductsByCategoryIds', [ProductController::class, 'getProductsByCategoryIds']);
Route::get('/getMangasByCategoryIds', [MangaController::class, 'getMangasByCategoryIds']);

//avatar
Route::post('/avatar', [UserController::class, 'store']);
Route::get('/avatar', [UserController::class, 'index']);
//router for room chat
Route::get('/room-chat', [RoomChatController::class, 'index']);
Route::post('/room-chat', [RoomChatController::class, 'store']);
// router for payment
Route::post('/vnpay-payment', [PaymentController::class, 'vnpay_payment']);
Route::get('/vnpay_callback', [PaymentController::class, 'vnpay_callback']);
//login_forum
Route::post('/login_forum', [UserController::class, 'login_forum']);
//show product admin
Route::get('/show-product/{id}', [ProductController::class, 'show_admin']);
//edit product
Route::post('/update-product/{id}', [ProductController::class, 'update']);