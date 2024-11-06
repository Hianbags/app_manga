@extends('dashboard')

@section('content')
<div class="main-panel">
    <div class="content-wrapper">
        <div class="page-header">
            <nav aria-label="breadcrumb">
                <ul class="breadcrumb">
                    <li class="breadcrumb-item active" aria-current="page"></li>
                </ul>
            </nav>
        </div>
        <div class="row">
            <div class="col-12 grid-margin stretch-card">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Danh sách truyện</h4>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Ảnh</th>
                                        <th>Tiêu đề</th>
                                        <th>Tác giả</th>
                                        <th>Mô tả nội dung</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody id="stories-table-body">
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        loadStories();
    });

    function loadStories() {
        fetch('https://magiabaiser.id.vn/api/manga-admin')
            .then(response => response.json())
            .then(data => {
                const storiesTableBody = document.getElementById('stories-table-body');
                storiesTableBody.innerHTML = '';
                data.data.forEach(story => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>${story.id}</td>
                        <td><img src="${story.image}" alt="story image" style="max-width: 100px;"></td>
                        <td>${story.title}</td>
                        <td>${story.author}</td>
                        <td>${truncateDescription(story.description)}</td>
                        <td>
                            <button onclick="editStory(${story.id})">Sửa</button>
                            <button onclick="addChapter(${story.id})">Thêm Chapter</button>
                            <button onclick="viewChapters(${story.id})">Danh sách Chapter</button>
                            <button onclick="deleteStory(${story.id})">Xóa</button>
                        </td>
                    `;
                    storiesTableBody.appendChild(row);
                });
            })
            .catch(error => console.error('Error fetching stories:', error));
    }

    function editStory(mangaId) {
        window.location.href = `/manga/edit?manga_id=${mangaId}`;
    }

    function addChapter(mangaId) {
        window.location.href = `add-chapter-page?manga_id=${mangaId}`;
    }

    function viewChapters(mangaId) {
        window.location.href = `/manga/chapters?manga_id=${mangaId}`;
    }

    function deleteStory(mangaId) {
        if (confirm('Bạn có chắc chắn muốn xóa truyện này không?')) {
            fetch(`/api/manga/${mangaId}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => {
                if (response.ok) {
                    alert('Xóa truyện thành công');
                    loadStories();
                } else {
                    alert('Xóa truyện thất bại');
                }
            })
            .catch(error => console.error('Error deleting story:', error));
        }
    }

    function truncateDescription(description, maxWords = 10) {
        const words = description.split(' ');
        if (words.length <= maxWords) {
            return description;
        } else {
            return words.slice(0, maxWords).join(' ') + '...';
        }
    }
</script>
@endsection
