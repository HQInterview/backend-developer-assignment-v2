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

{!! Form::open(['route' => ['bid.store',  $auction->id],'class' => 'form-horizontal']) !!}


{{-- Name form Begin --}}
<div class="form-group clearfix">
	{!! Form::label('price', 'Price:', ['class' => 'col-sm-2 control-label']) !!}
	<div class="col-sm-4">
		{!! Form::text('price', null, ['class' => 'form-control']) !!}
	</div>
</div>
{{-- Name form End --}}


{!! Form::submit('Create Bid', ['class' => 'btn btn-sm btn-info']) !!}		

{!! Form::close() !!}