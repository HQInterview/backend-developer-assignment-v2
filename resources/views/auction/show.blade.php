@extends('layouts.master')

@section('content')
<h4>Auction Bids for</h4>
<div class="panel panel-default">
	<div class="panel-heading">
		<h3 class="panel-title">{{ $auction->name }}</h3>
	</div>
	<div class="panel-body">
		{{ $auction->description }}
	</div>
	<div class="panel-footer">
		Time remaining: <br>
		<Countdown date="{{ $auction->unavailable_at }}"></Countdown>
	</div>
</div>


{{-- show bids related to auction --}}
<div class="row">
	<h4>Bids for {{ $auction->name }}</h4>
	<div class="col-sm-5">
		@if ($auction->bids->isEmpty())
		<div class="well">
			No Bid yet!
		</div>
		@else
		<table class="table table-striped table-hover">
			<thead>
				<tr>
					<th>User Name</th>
					<th>Price</th>
					<th>Name</th>
				</tr>
			</thead>
			<tbody>
				@foreach ($bids as $bid)
				<tr>
					<td>{{ $bid->user->name }}</td>
					<td>{{ $bid->price }}</td>
					<td>{{ $bid->name }}</td>
				</tr>
				@endforeach
			</tbody>
		</table>
		@endif
		{{-- Paginate links --}}
		{{ $bids->links() }}
	</div>
</div>

{{-- show new bid form --}}
<h4>Create a new <strong>bid</strong></h4>
<div class="container">
	@include('bid.forms.create', [$auction->id])
</div>



@endsection