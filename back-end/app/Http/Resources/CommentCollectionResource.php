<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\ResourceCollection;

class CommentCollectionResource extends ResourceCollection
{
    /**
     * Transform the resource collection into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray($request): array
    {
        return [
            'data' => $this->collection->map(function ($comment) {
                return [
                    'id' => $comment->id,
                    'user' => $comment->user->name,
                    'content' => $comment->content,
                    'created_at' => $comment->created_at->format('s:i:H d-m-Y'),
                ];
            }),
        ];
    }

    /**
     * Customize the response for the resource collection.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Illuminate\Http\JsonResponse|\Illuminate\Http\Response  $response
     * @return void
     */
    public function withResponse($request, $response)
    {
        if ($this->resource->isNotEmpty()) {
            $response->setData(array_merge(
                $response->getData(true),
                ['meta' => [
                    'total' => $this->resource->total(),
                    'per_page' => $this->resource->perPage(),
                    'current_page' => $this->resource->currentPage(),
                    'last_page' => $this->resource->lastPage(),
                    'from' => $this->resource->firstItem(),
                    'to' => $this->resource->lastItem(),
                ]]
            ));
        }
    }
}
