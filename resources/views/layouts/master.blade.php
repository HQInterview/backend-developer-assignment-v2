
<!DOCTYPE html>
<!--[if IE 9]><html class="ie9"> <![endif]-->
<!--[if !IE]><html><![endif]-->
<head>
	<title>Hotel Quickly - @yield('title')</title>

	<!-- Bootstrap Core CSS -->
	<link href="{{ asset('css/app.css') }}" rel="stylesheet">
</head>
<body>
	
	<!-- Navigation and Menubar -->
	@include('layouts._partials.navbar_menu')

	<div class="container" id="app">
		@include('layouts._partials.flash')

		<!-- Site content -->
		@yield('content')
	</div>
	<!-- Bootstrap Core JavaScript -->
	<script src="{{ asset('js/app.js') }}"></script>
	
	<!-- extra js -->
	@yield('extra_js')

</body>
</html>




