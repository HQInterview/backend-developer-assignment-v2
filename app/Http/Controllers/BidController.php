<?php

namespace App\Http\Controllers;

use App\Auction;
use App\Bid;
use Auth;

use Illuminate\Http\Request;

class BidController extends Controller
{

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request, $id)
    {

     $auction = Auction::timeAvailable()->active()->where('id', $id)->firstOrFail();
     $bid = new Bid($request->all());
     if ($bid->validate($request->all(), $auction)){

            // save bid and set relations
        $bid->user()->associate(Auth::user());
        $bid->auction()->associate($auction);
        $bid->save();

            // add extra minute to auction on last minute
        $auction->addExtraMinute();
        $auction->save();

        return redirect()->route('auction.show', ['id' => $id])
                             ->with('flash_message', 'Your bid has been successfully created!'); 

          } else {
                return back()->withErrors($bid->errors())->withInput();
       }


    }

    public function show(int $bidId)
    {
        $bid = Bid::findOrfail($bidId);
        if ($bid->user_id == Auth::user()->id) {
            return view('bid.show', compact('bid'));
        }            
        return abort(401, 'Not authorized');
        
    }


}
