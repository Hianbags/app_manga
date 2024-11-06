@extends('dashboard')
@section('content')
<div class="main-panel">
    <div class="content-wrapper">
        <div class="page-header">
            <h3 class="page-title">Thêm Chapter</h3>
            <nav aria-label="breadcrumb">
                <ul class="breadcrumb">
                    <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Thêm Chapter</li>
                </ul>
            </nav>
        </div>
        <div class="row">
            <div class="col-md-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <div class="form-group">
                            <label>ID đã chọn:</label>
                            <p>{{ request()->get('manga_id') }}</p>
                        </div>
                        <form id="addChapterForm" enctype="multipart/form-data">
                            @csrf
                            <input type="hidden" name="manga_id" value="{{ request()->get('manga_id') }}">
                            <div class="form-group">
                                <label for="zip_file">Chọn file ZIP:</label>
                                <input type="file" class="form-control" id="zip_file" name="zip_file">
                            </div>
                            <button type="submit" class="btn btn-primary">Thêm Chapter</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const addChapterForm = document.getElementById('addChapterForm');
        addChapterForm.addEventListener('submit', function (event) {
            event.preventDefault();
            const formData = new FormData(addChapterForm);
            fetch('https://magiabaiser.id.vn/api/chapter', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    // Redirect to another page or perform any other action upon success
                } else {
                    alert(data.message);
                }
            })
            .catch(error => {
                console.error('Error adding chapter:', error);
                alert('Failed to add chapter. Please try again later.');
            });
        });
    });
</script>

@endsection
