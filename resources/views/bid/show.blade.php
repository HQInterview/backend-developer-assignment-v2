@extends('layouts.master')

@section('content')

<h4>Your Bid status for <b>{{ $bid->auction->name }}</b></h4>

@if ($bid->auction->bids->last()->id == $bid->id)
	{{-- bid condition id is a winner --}}
	@if ($bid->auction->minBidsAvailable())
	<div class="panel panel-default">
		<div class="panel-body">
			<div class="alert alert-success">
				<strong>Your Bid was won the auction</strong>
			</div>
		</div>
	</div>
	@endif
{{-- bid condition if not winner --}}
@else
<div class="panel panel-default">
	<div class="panel-body">
		<div class="alert alert-warning">
			<strong>Your Bid wasn't winner, sorry!</strong>
		</div>
	</div>
</div>

@endif



@endsection