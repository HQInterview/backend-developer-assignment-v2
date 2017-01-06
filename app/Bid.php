<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Bid extends Model
{

   private $errors;
   
   protected $fillable = ['price'];


 // rules for validation
   private $rules = [
   'price' => 'sometimes|required|numeric',
   ];



    /**
    * Get the user associated to bid.
    */
    public function user()
    {
    	return $this->belongsTo('App\User');
    }



    /**
    * Get the auction associated to bid.
    */
    public function auction()
    {
    	return $this->belongsTo('App\Auction');
    }



    /**
     * Validate Bid request
     * @param  Array $data    Requests field
     * @param  Object $auction Auction instance
     * @return boolean          validaton results
     */
    public function validate($data, $auction)
    {
        // make a new validator object
        $v = \Validator::make($data, $this->rules);

        $v->sometimes('price', 'size:5% bigger than old price', function($input) use ($auction)
        {
            $lastBid = $auction->bids->last();
            $diffPercent = (!is_null($lastBid)) ? $lastBid['price'] * 0.05 : $lastBid['price'] = 0 ;
            return !($input['price'] - $lastBid['price'] >=  $diffPercent );
        });

        // check for failure
        if ($v->fails($auction))
        {
            // set errors and return false
            $this->errors = $v->errors();
            return false;
        }

        // validation pass
        return true;
    }


    /**
     * Validation errors
     * @return Array error bag arrays
     */
    public function errors()
    {
        return $this->errors;
    }
}
