<?php

namespace App;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

class Auction extends Model
{   

     // Mass assignment fields fillable
     protected $fillable = ['name', 'description', 'min_bids', 'active', 'user_id'];


     /**
     * The attributes that should be mutated to dates.
     *
     * @var array
     */
     protected $dates = [
                     'created_at',
                     'updated_at',
                     'unavailable_at'
                        ]; 

    /**
    * Get the auction associated user.
    */
    public function user()
    {
    	return $this->belongsTo('App\User');
    }


    /**
    * Get the auction associated Bids.
    */
    public function bids()
    {
        return $this->hasMany('App\Bid');
    }

    
    /**
     * query scope for auctions are active
     * @param  Object $query current query
     * @return Object        model query
     */
    public function scopeActive($query)
    {
        return $query->where('active', true);
    } 


    /**
    * query scope for auctions have times
    * @param  Object $query current query
    * @return Object        model query
    */
    public function scopeTimeAvailable($query)
    {
        $now = Carbon::now();
        return $query->where('unavailable_at', '>=' , $now);
    }


    /**
    * query scope for auctions was finished
    * @param  Object $query current query
    * @return Object        model query
    */
    public function scopeFinished($query)
    {
        $now = Carbon::now();
        return $query->where('unavailable_at', '<' , $now);
    }


    /**
    * add extra time to auction have only 60sec
    * left to bid for prevent last second bid
    */
    public function addExtraMinute()
    {
        $diff = Carbon::now()->diffInSeconds($this->unavailable_at, false);

        if ( $diff > 0 && $diff <= 60){
            $this->unavailable_at = $this->unavailable_at->addMinute();
            return true;
        }
        return false;
    }


    /**
    * deactive auction
    */
    public function deactive()
    {
       $this->active = false;
       return $this->save();
    }


    /**
    * check for auction that have
    * valid bid on min_bids field
    */
    public function minBidsAvailable()
    {
     return ($this->min_bids <= $this->bids->count());
    }


}
