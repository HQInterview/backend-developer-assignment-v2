@extends('layouts.master')

@section('content')

<div class="container">
	<div class="row">
		<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
			<h4>New Room Autcion</h4>
			
			{{-- Error Messages --}}
			@if (count($errors) > 0)
			<div class="alert alert-danger">
				<ul>
					@foreach ($errors->all() as $error)
					<li>{{ $error }}</li>
					@endforeach
				</ul>
			</div>
			@endif
			
			{!! Form::open(['route' => 'auction.store','class' => 'form-horizontal']) !!}
			
			{{-- Name form Begin --}}
			<div class="form-group clearfix">
				{!! Form::label('name', 'Room Name:', ['class' => 'col-sm-2 control-label']) !!}
				<div class="col-sm-7">
					{!! Form::text('name', null, ['class' => 'form-control']) !!}
				</div>
			</div>
			{{-- Name form End --}}

			{{-- description form Begin --}}
			<div class="form-group clearfix">
				{!! Form::label('description', 'Description:', ['class' => 'col-sm-2 control-label']) !!}
				<div class="col-sm-7">
					{!! Form::textarea('description', null, ['class' => 'form-control']) !!}
				</div>
			</div>
			{{-- description form End --}}


			{{-- min_bids form Begin --}}
			<div class="form-group clearfix">
				{!! Form::label('min_bids', 'Min Bids:', ['class' => 'col-sm-2 control-label']) !!}
				<div class="col-sm-7">
					{!! Form::text('min_bids', null, ['class' => 'form-control']) !!}
				</div>
			</div>
			{{-- min_bids form End --}}


			{!! Form::submit('Save', ['class' => 'btn btn-lg btn-info']) !!}		

			{!! Form::close() !!}
		</div>
	</div>
</div>

@endsection