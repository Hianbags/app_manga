<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="description" content="Responsive HTML Admin Dashboard Template based on Bootstrap 5">
    <meta name="author" content="NobleUI">
    <meta name="keywords" content="nobleui, bootstrap, bootstrap 5, bootstrap5, admin, dashboard, template, responsive, css, sass, html, theme, front-end, ui kit, web">

    <title>Manga</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <!-- End fonts -->
    <!-- core:css -->
    <link rel="stylesheet" href="../assets/vendors/core/core.css">
    <!-- endinject -->

    <!-- Plugin css for this page -->
    <link rel="stylesheet" href="../assets/vendors/flatpickr/flatpickr.min.css">
    <!-- End plugin css for this page -->
    <link rel="stylesheet" href="{{ asset('assets/vendors/core/core.css') }}">
    <script src="{{ asset('assets/vendors/core/core.js') }}"></script>
    
    <!-- inject:css -->
    <link rel="stylesheet" href="../assets/fonts/feather-font/css/iconfont.css">
    <link rel="stylesheet" href="../assets/vendors/flag-icon-css/css/flag-icon.min.css">
    <!-- endinject -->

    <!-- Layout styles -->
    <link rel="stylesheet" href="../assets/css/demo2/style.css">
    <!-- End layout styles -->

    <link rel="shortcut icon" href="../assets/images/favicon.png" />
</head>

<body>
    <div class="main-wrapper">
        <!-- partial:partials/_sidebar.html -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <a href="#" class="sidebar-brand">
                    Trang quản lý
                </a>
                <div class="sidebar-toggler not-active">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
            </div>
            <div class="sidebar-body">
                <ul class="nav">
                    <li class="nav-item nav-category">Quản Lý Manga</li>
                    <li class="nav-item"></li>
                    <li class="nav-item"></li>
                    <li class="nav-item"></li>
                    <li class="nav-item">
                        <a class="nav-link" data-bs-toggle="collapse" href="#tables" role="button" aria-expanded="false" aria-controls="tables">
                            <i class="link-icon" data-feather="layout"></i>
                            <span class="link-title">Manga</span>
                            <i class="link-arrow" data-feather="chevron-down"></i>
                        </a>
                        <div class="collapse" id="tables">
                            <ul class="nav sub-menu">
                                <li class="nav-item">
                                    <a href="{{ route('mangalist') }}" class="nav-link">Danh Sách Manga</a>
                                </li>
                                <li class="nav-item">
                                    <a href="{{ route('createManga') }}" class="nav-link">Thêm Manga</a>
                                </li>
                                <li class="nav-item">
                                    <a href="{{ route('categorylist') }}" class="nav-link">Thêm thể loại manga</a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">Quản lý sản phẩm </li>
                    <li class="nav-item">
                        <a class="nav-link" data-bs-toggle="collapse" href="#forms" role="button" aria-expanded="false" aria-controls="forms">
                            <i class="link-icon" data-feather="edit"></i>
                            <span class="link-title
                            ">Sản Phẩm</span>
                            <i class="link-arrow
                            " data-feather="chevron-down"></i>
                        </a>
                        <div class="collapse" id="forms">
                            <ul class="nav sub-menu">
                                <li class="nav-item">
                                    <a href="{{ route('productlist') }}" class="nav-link">Danh Sách Sản Phẩm</a>
                                </li>
                                <li class="nav-item">
                                    <a href="{{ route('productadd') }}" class="nav-link">Thêm sản phẩm</a>
                                </li>
                            </ul>
                        </div>
                    </li>
                    <li class="nav-item">Quản lý đơn hàng </li>
                    <li class="nav-item">
                        <a class="nav-link" data-bs-toggle="collapse" href="#orders" role="button" aria-expanded="false" aria-controls="orders">
                            <i class="link-icon" data-feather="edit"></i>
                            <span class="link-title
                            ">Đơn Hàng</span>
                            <i class="link-arrow
                            " data-feather="chevron-down"></i>
                        </a>
                        <div class="collapse" id="orders">
                            <ul class="nav sub-menu">
                                <li class="nav-item">
                                  <a href="{{ route('orderlist') }}" class="nav-link">Danh Sách Đơn Hàng</a>
                                </li>
                                <li class="nav-item">
                                    <a href="pages/forms/advanced-elements.html" class="nav-link">Thêm Đơn Hàng</a>
                                </li>
                            </ul>
                        </div>
                    </li>
                </ul>
            </div>
        </nav>
        <!-- partial -->
        <div class="page-wrapper">
            <div class="page-header">
                <h3 class="page-title">
                    <span class="page-title"></span>
                </h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="#">Tables</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Data table</li>
                    </ol>
                </nav>
            </div>
            <div class="row">
                <div class="col-12 grid-margin stretch-card">
                    <div class="card">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        @yield('content')
                                    </thead>
                                                </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="../assets/vendors/core/core.js"></script>
    <script src="../assets/vendors/flatpickr/flatpickr.min.js"></script>
    <script src="../assets/vendors/apexcharts/apexcharts.min.js"></script>
    <script src="../assets/vendors/feather-icons/feather.min.js"></script>
    <script src="../assets/js/template.js"></script>
    <script src="../assets/js/dashboard-dark.js"></script>
</body>
</html>
