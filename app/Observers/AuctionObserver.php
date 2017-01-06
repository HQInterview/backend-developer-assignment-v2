<?php

namespace App\Observers;

use App\Auction;
use Carbon\Carbon;

class AuctionObserver
{

    /**
     * Listen to the Auction creating event.
     *
     * @param  Auction  $auction
     * @return void
     */
    public function creating(Auction $auction)
    {
        
        $auction->active = true;        
        $auction->unavailable_at = Carbon::now()->addMinutes(10);        

    }

    
}