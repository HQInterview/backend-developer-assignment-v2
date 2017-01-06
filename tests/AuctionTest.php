<?php

use Illuminate\Foundation\Testing\WithoutMiddleware;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Illuminate\Foundation\Testing\DatabaseTransactions;

use App\Bid;
use App\User;
use App\Auction;
use Carbon\Carbon;

class AuctionTest extends TestCase
{	
    protected $user;

    protected $auction;

	/**
	 * Set up test for auction
	 */
	protected function setUp()
	{
	     parent::setUp();

           // create user test
           $this->user =  User::firstOrCreate([
             'name' => 'testName testLastName',
             'email' => 'test@example.com',
             'callback' => 'http://example.com'
             ]);

            // create auction test
           $this->auction = Auction::firstOrCreate([
            'name' => 'testAuction',
            'description' => 'testAuction description',
            'user_id' => $this->user->id,
            'active' => 1,
            'min_bids' => 3
                ]);
    }

    /**
     * Test index autions.
     *
     * @return void
     */
    public function testIndexAuction()
    {
        $this->visitRoute('auction.index')
                ->see('Rooms Auction');
    }




    /**
     * Test Creating an autions.
     *
     * @return void
     */
    public function testCreateAuction()
    {		

      $this->be($this->user);

      $this->visitRoute('auction.create')
              ->type('Test Room', 'name')
              ->type('Description for Auction', 'description')
              ->type('3', 'min_bids')
              ->press('Save')
              ->see('Test Room')
              ->see('Description for Auction');
  }


    /**
     * set a bid on an new auction
     * @return void
     */
    public function testBidCreating()
    {
    	// create new auction and get auction
    	$auction = factory(Auction::class)->create();

    	// create a new bid on created auction
    	$this->actingAs($this->user)
              ->visitRoute('auction.show', [$auction->id])
              ->type('100', 'price')
              ->press('Create Bid')
              ->see('100');
    }

    /**
     * Test Extra minutes to auction model
     * on last minute
     * @return void 
     */
    public function testAddExtraMinuteToAuction()
    {
        $unavailable_at = Carbon::now()->addSeconds(30);
        $this->auction->unavailable_at = $unavailable_at;
        $responseTest = false;

        $diff = Carbon::now()->diffInSeconds($unavailable_at, false);
        if ( $diff > 0 && $diff <= 60){
            $responseTest = true;
        }
        $responseModel = $this->auction->addExtraMinute();

        $this->assertEquals($responseTest, $responseModel);
    }


    /**
     * Test min bid available on aution model
     * @return void 
     */
    public function testMinBidsAvailable()
    {   
        $i = 1;
        while ($i <= 4) {
           $bid = new Bid;
           $bid->price = 200 * $i;
           $bid->user_id = $this->user->id;
           $bid->auction_id = $this->auction->id;
           $bid->save();
           $i++;
       }

       $this->assertEquals(
                ($this->auction->min_bids <= $this->auction->bids->count()), 
                $this->auction->minBidsAvailable()
                );
    }

    /**
     * Test active auction method model
     * @return void 
     */
    public function testActiveAuctions()
    {
        $auctionActive = Auction::where('active', true);
        $this->assertEquals(
                Auction::active(), 
                $auctionActive
                );
    }

    /**
     * Test TimeAvailable auction method model
     * @return void 
     */
    public function testTimeAvailables()
    {
        $now = Carbon::now();
        $timeAvailable = Auction::where('unavailable_at', '>=' , $now);
        $this->assertEquals(
                Auction::timeAvailable(), 
                $timeAvailable
                );
    }


    /**
     * Test finished auction method model
     * @return void 
     */
    public function testFinished()
    {
        $now = Carbon::now();
        $finished = Auction::where('unavailable_at', '<' , $now);
        $this->assertEquals(
                Auction::finished(), 
                $finished
                );
    }


    public static function tearDownAfterClass()
    {
        // $this->auction->delete();
        // $this->user->delete();
    }
}
