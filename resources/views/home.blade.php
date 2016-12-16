@extends('layouts.master')

@section('content')
<div class="container">
    <div class="row">
        <div class="col-md-8 col-md-offset-2">
            <div class="panel panel-default">
                <div class="panel-heading">Dashboard</div>

                <div class="panel-body">
                    <h3><a href="{{ route('auction.index') }}">Auctions</a></h3>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
