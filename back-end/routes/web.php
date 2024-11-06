    <?php

    use App\Http\Controllers\API_BackEnd\Manga\MangaController;
    use Illuminate\Support\Facades\Route;
    use App\Http\Controllers\API_BackEnd\Shop\CKEditorController;
use App\Http\Controllers\API_BackEnd\Shop\ProductController;
use App\Http\Controllers\API_BackEnd\User\UserController;
    use App\Http\Controllers\ChatsController;
    use App\Http\Controllers\MessageController;

    /*
    |--------------------------------------------------------------------------
    | Web Routes
    |--------------------------------------------------------------------------
    |
    | Here is where you can register web routes for your application. These
    | routes are loaded by the RouteServiceProvider and all of them will
    | be assigned to the "web" middleware group. Make something great!
    |
    */

    Route::get('/', function () {
        return view('dashboard');
    });

    Route::get('/login', function () {
        return view('auth.login');
    });

    Route::post('/login_forum', [UserController::class, 'login_forum'])->name('login_forum');

    Route::post('logout', [UserController::class, 'logout'])->name('logout');
    

    Route::get('/admin-manga', function () {
        return view('layouts.MangaList.manga');
    })->name('mangalist');
    Route::get('/admin-create-manga', function () {
        return view('layouts.MangaList.create');
    })->name('createManga');
    Route::get('/add-chapter-page', function () {
        return view('layouts.MangaList.chapter');
    })->name('createChapter');
    Route::get('/adminorder', function () {
        return view('layouts.MiniShop.order');
    })->name('orderlist');
    Route::put('/orders/{id}', 'OrderController@update')->name('orders.update');
    Route::get('/admin-product', function () {
        return view('layouts.MiniShop.product');
    })->name('productadd');
    Route::post('/ckeditor/upload', [CKEditorController::class, 'upload'])->name('ckeditor.upload');


    Route::get('/manga/edit', function () {
        return view('layouts.MangaList.edit_manga');
    })->name('editManga');

    Route::get('/manga/chapters', function () {
        return view('layouts.MangaList.chapter_list');
    })->name('chapterlist');

    Route::get('/category-manga', function () {
        return view('layouts.MangaList.categories');
    })->name('categorylist');

    Route::get('/list-product', function () {
        return view('layouts.MiniShop.product_list');
    })->name('productlist');

    Route::get('/edit-product', function () {
        return view('layouts.MiniShop.product_edit');
    });
    Route::get('/show-product' , function () {
        return view('layouts.MiniShop.product_show');
    });
    