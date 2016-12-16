<?php


Route::group(['middleware' => 'auth'], function() {

	// auction route
	Route::resource('auction', 'AuctionController');

	// post bid to asuction route
	Route::post('auction/{auctionId}/bid', ['uses' => 'BidController@store', 'as' => 'bid.store']);

	// profile routes
	Route::get('profile', ['uses' => 'Auth\AccountController@edit','as' => 'profile.edit']);
	Route::post('profile', ['uses' => 'Auth\AccountController@update','as' => 'profile.update']);
});

Auth::routes();

Route::get('/', 'HomeController@index');


