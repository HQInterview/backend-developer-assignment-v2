<?php

namespace App\Http\Controllers;

use Auth;
use Cache;
use App\Auction;
use Illuminate\Http\Request;
use App\Http\Requests\StoreAuctionRequest;

class AuctionController extends Controller
{
    /**
     * Display a listing of the auctions.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {   
        $auctions = Auction::active()->timeAvailable()->orderBy('created_at', 'desc');
        return view('auction.index', compact('auctions'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('auction.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoreAuctionRequest $request)
    {
        Auth::user()->auctions()->create($request->all());
        
        return redirect()->route('auction.index')
                            ->with('flash_message', 'Your auction has been successfully created!');
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {

       $auction = Auction::timeAvailable()->active()->where('id', $id)->firstOrFail();
       $bids = $auction->bids()->paginate(7);
       return view('auction.show', compact('auction', 'bids'));

   }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
