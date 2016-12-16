@extends('layouts.master')

@section('content')

<h1>Rooms Auction</h1>

<hr/>

@foreach($auctions as $auction)

<div class="panel panel-default">
	
	<div class="panel-heading">
		<a href="{{ url('/auction', $auction->id) }}">{{ $auction->name }}</a>
	</div>
	
	<div class="panel-body">
		{{ $auction->description }}
	</div>
	<div class="panel-footer">
		Time remaining: <br>
		{{ $auction->updated_at }}
		<Countdown date="{{ $auction->unavailable_at }}"></Countdown>
	</div>

</div>

@endforeach

@endsection