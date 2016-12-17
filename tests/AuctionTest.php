<?php

use Illuminate\Foundation\Testing\WithoutMiddleware;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Illuminate\Foundation\Testing\DatabaseTransactions;

use App\User;
use App\Auction;

class AuctionTest extends TestCase
{	
	protected $user;

	/**
	 * Set up test for auction
	 */
	public function setUp()
	{
		parent::setUp();

		$this->user =  User::firstOrCreate([
			'name' => 'testName testLastName',
			'email' => 'test@example.com',
			'callback' => 'http://example.com'
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
}
