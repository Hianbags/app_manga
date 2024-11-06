@extends('dashboard')

@section('content')
<div class="main-panel">
    <div class="content-wrapper">
        <div class="page-header">
            <h4 class="page-title">Danh sách Chapter</h4>
            <nav aria-label="breadcrumb">
                <ul class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/manga">Danh sách Truyện</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Danh sách Chapter</li>
                </ul>
            </nav>
        </div>
        <div class="row">
            <div class="col-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Chapters</h4>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Tiêu đề</th>
                                        <th>Hành động</th> <!-- Thêm cột Hành động -->
                                    </tr>
                                </thead>
                                <tbody id="chapters-table-body">
                                    <!-- Data sẽ được nạp ở đây -->
                                </tbody>
                            </table>
                        </div>
                        <button onclick="goBack()" class="btn btn-secondary mt-3">Quay lại</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const mangaId = {{ request()->get('manga_id') }};
        loadChapters(mangaId);
    });

    function loadChapters(mangaId) {
        fetch(`/api/chapter/${mangaId}`)
            .then(response => response.json())
            .then(result => {
                console.log('Fetched data:', result);
                const chaptersTableBody = document.getElementById('chapters-table-body');
                chaptersTableBody.innerHTML = '';

                if (Array.isArray(result.data)) {
                    result.data.forEach(chapter => {
                        const row = document.createElement('tr');
                        row.innerHTML = `
                            <td>${chapter.id}</td>
                            <td>${chapter.title}</td>
                            <td>
                                <button class="btn btn-danger btn-sm" onclick="deleteChapter(${chapter.id})">Xóa</button>
                            </td>
                        `;
                        chaptersTableBody.appendChild(row);
                    });
                } else {
                    console.error('Expected an array but received:', result.data);
                    chaptersTableBody.innerHTML = '<tr><td colspan="3">Không có dữ liệu chapters.</td></tr>';
                }
            })
            .catch(error => console.error('Error fetching chapters:', error));
    }

    function deleteChapter(chapterId) {
        if (confirm('Bạn có chắc chắn muốn xóa chapter này?')) {
            fetch(`/api/chapter?chapter_id=${chapterId}`, {
                method: 'DELETE',
                headers: {
                    'X-CSRF-TOKEN': '{{ csrf_token() }}'
                }
            })
            .then(response => {
                if (response.ok) {
                    alert('Xóa thành công!');
                    loadChapters({{ request()->get('manga_id') }}); // Load lại danh sách sau khi xóa
                } else {
                    alert('Xóa thất bại.');
                }
            })
            .catch(error => console.error('Error deleting chapter:', error));
        }
    }

    function goBack() {
        window.history.back();
    }
</script>
@endsection
