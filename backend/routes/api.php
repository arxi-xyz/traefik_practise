<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Http\JsonResponse;

Route::get('/health_check', function (Request $request) {
    return response()->json([
        'message' => 'Laravel Backend is Running'
    ]);
});
