@extends('dashboard')

@section('content')
<div class="main-panel">
    <div class="content-wrapper">
        <div class="page-header">
            <h3 class="page-title">Sửa Sản Phẩm</h3>
            <nav aria-label="breadcrumb">
                <ul class="breadcrumb">
                    <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Sửa Sản Phẩm</li>
                </ul>
            </nav>
        </div>
        <div class="row">
            <div class="col-md-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <form id="editProductForm" method="POST" enctype="multipart/form-data">
                            @csrf
                            <div class="form-group">
                                <label for="name">Tên sản phẩm:</label>
                                <input type="text" class="form-control" name="name" id="name" required>
                            </div>
                            <div class="form-group">
                                <label for="description">Mô tả sản phẩm:</label>
                                <textarea class="form-control" name="description" id="description"></textarea>
                            </div>
                            <div class="form-group">
                                <label for="price">Giá:</label>
                                <input type="number" step="0.01" class="form-control" name="price" id="price" required>
                            </div>
                            <div class="form-group">
                                <label for="images">Hình ảnh:</label>
                                <input type="file" class="form-control" name="images[]" id="images" multiple>
                                <div id="imagePreview" class="mt-2"></div>
                            </div>
                            <button type="submit" class="btn btn-primary">Cập nhật sản phẩm</button>
                        </form>
                        <div id="result" class="mt-3"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- CKEditor 5 Classic with image upload support -->
<script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        ClassicEditor
            .create(document.querySelector('#description'), {
                ckfinder: {
                    uploadUrl: '{{ route('ckeditor.upload') }}?_token={{ csrf_token() }}'
                },
                toolbar: [
                    'heading', '|', 
                    'bold', 'italic', 'link', 'bulletedList', 'numberedList', 'blockQuote', 
                    'undo', 'redo', 'ckfinder', 'imageUpload', 'imageResize'
                ],
                image: {
                    toolbar: [
                        'imageTextAlternative', 'imageStyle:full', 'imageStyle:side', 'imageResize'
                    ],
                    resizeOptions: [
                        {
                            name: 'resizeImage:original',
                            value: null,
                            label: 'Original',
                        },
                        {
                            name: 'resizeImage:50',
                            value: '50',
                            label: '50%',
                        },
                        {
                            name: 'resizeImage:75',
                            value: '75',
                            label: '75%',
                        }
                    ],
                    resizeUnit: '%'
                }
            })
            .then(editor => {
                window.editor = editor;
                fetchProductDetails(); // Fetch product details after CKEditor is initialized
            })
            .catch(error => {
                console.error(error);
            });

        const editProductForm = document.getElementById('editProductForm');
        const productId = {{ request()->get('product_id') }};
        editProductForm.addEventListener('submit', function (event) {
            event.preventDefault();
            const formData = new FormData(editProductForm);
            const apiUrl = '/api/update-product/' + productId;
            fetch(apiUrl, {
                method: 'POST', // Use POST method as required by the API
                headers: {
                    'X-CSRF-TOKEN': document.querySelector('input[name="_token"]').value
                },
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                let resultDiv = document.getElementById('result');
                if (data.message) {
                    resultDiv.innerHTML = `<div class="alert alert-danger">${data.message}</div>`;
                } else {
                    resultDiv.innerHTML = `<div class="alert alert-success">Sản phẩm đã được cập nhật thành công!</div>`;
                }
            })
            .catch(error => {
                document.getElementById('result').innerHTML = `<div class="alert alert-danger">${error}</div>`;
            });
        });

        function fetchProductDetails() {
            const apiUrl = '/api/show-product/' + productId;

            fetch(apiUrl)
                .then(response => response.json())
                .then(data => {
                    const product = data.data;
                    document.getElementById('name').value = product.name;
                    window.editor.setData(product.description);
                    document.getElementById('price').value = product.price;

                    const imagePreviewDiv = document.getElementById('imagePreview');
                    product.images.forEach(image => {
                        const imgElement = document.createElement('img');
                        imgElement.src = image;
                        imgElement.alt = 'Product Image';
                        imgElement.style.maxWidth = '100px';
                        imgElement.style.marginRight = '10px';
                        imagePreviewDiv.appendChild(imgElement);
                    });
                })
                .catch(error => {
                    console.error('Error fetching product details:', error);
                });
        }
    });
</script>
<style>
    .ck-editor__editable {
        color: black !important;
        height: 400px;
    }
</style>
@endsection
