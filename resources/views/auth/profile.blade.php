@extends('layouts.master')

@section('content') 

<div class="container">
  <div class="row">
    <div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
     <h3>Personal info</h3>

     {!! Form::open(['route' => 'profile.update','class' => 'form-horizontal']) !!}
     
     {{-- Name form Begin --}}
     <div class="form-group clearfix">
      {!! Form::label('name', 'Full Name:', ['class' => 'col-sm-2 control-label']) !!}
      <div class="col-sm-7">
        {!! Form::text('name', $user->name, ['class' => 'form-control']) !!}
      </div>
    </div>
      {{-- Name form End --}}


    {{-- Name form Begin --}}
     <div class="form-group clearfix">
      {!! Form::label('name', 'CallBack Url:', ['class' => 'col-sm-2 control-label']) !!}
      <div class="col-sm-7">
        {!! Form::text('callback', $user->callback, ['class' => 'form-control']) !!}
      </div>
    </div>
    


    {!! Form::submit('Save', ['class' => 'btn btn-md btn-info']) !!}    

    {!! Form::close() !!}
  </div>
</div>
</div>
@endsection
