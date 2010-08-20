#import <UIKit/UIKit.h>

#include "cinder/app/AppCocoaTouch.h"
#include "cinder/app/Renderer.h"
#include "cinder/Surface.h"
#include "cinder/Xml.h"
#include "cinder/gl/Texture.h"
#include "cinder/Camera.h"
#include "HTTPWrapper.h"
//#include "FoodEvent.h"
#include "FreeFoodEvent.h"
#include "cinder/cocoa/CinderCocoaTouch.h"

using namespace ci;
using namespace ci::app;



class iphonenetworkApp : public AppCocoaTouch  {
  public:
	virtual void	setup();
	virtual void	resize( int width, int height );
	virtual void	update();
	virtual void	draw();
	virtual void	mouseDown( ci::app::MouseEvent event );
	virtual void		touchesBegan( TouchEvent event );
	//! Override to respond to movement (drags) during a multitouch sequence
	virtual void		touchesMoved( TouchEvent event );
	//! Override to respond to the end of a multitouch sequence
	virtual void		touchesEnded( TouchEvent event );
	
	ci::Matrix44f	mCubeRotation;
	ci::gl::Texture mTex;
	ci::CameraPersp	mCam;
	
	HTTPWrapper* request;
	
	//ASIHTTPRequest* temp;
	
	
	float testX,testY,testRadius;
	gl::Texture mapBG;
	UIImage* mapBGUI;
	bool convertedData;
	void makeUseable();
	NSMutableArray*	mFoodEvents;
};

void iphonenetworkApp::setup()
{
	mapBGUI = [[UIImage alloc] initWithContentsOfFile:@"map.png"];
	convertedData = false;
	request = [[HTTPWrapper alloc] init];
	[request setURL:@"http://api.freefood4free.org/events/new"];
	[request startRequest];
	mCubeRotation.setToIdentity();
	mapBG = gl::Texture( loadImage(loadResource("map.png")));
	// Create a blue-green gradient as an OpenGL texture
	Surface8u surface( 256, 256, false );
	Surface8u::Iter iter = surface.getIter();
	while( iter.line() ) {
		while( iter.pixel() ) {
			iter.r() = 0;
			iter.g() = iter.x();
			iter.b() = iter.y();
		}
	}
	
	mTex = gl::Texture( surface );
	NSLog(@"step 1");
}

void iphonenetworkApp::makeUseable(){
	if(!convertedData){
		NSMutableData* theData = [request data];
		mFoodEvents = [[NSMutableArray alloc] init];
		NSString* theString = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
		
		
		id foodEventReturnType = [theString JSONValue];
		BOOL validReturn = NO;
		NSString *classType = [NSString stringWithFormat:@"%@",[foodEventReturnType class]];
		
		if([classType isEqualToString:@"__NSCFDictionary"]){
			if([[foodEventReturnType objectForKey:@"success"] isEqualToString:@"no food events"]){
				
			}else if([foodEventReturnType objectForKey:@"failure"]){
				

			}
		}else{
			validReturn = YES;
		}
		
		if(validReturn){
			for(int i = 0; i < [foodEventReturnType count]; i++){
				FreeFoodEvent *tempFoodEvent = [[FreeFoodEvent alloc] init];
				[tempFoodEvent createFromDict:[foodEventReturnType objectAtIndex:i]];
				[mFoodEvents addObject:tempFoodEvent];
				//NSLog(@"totally fooded out");
			}
			for(int i = 0; i < [mFoodEvents count]; i++){
				[[mFoodEvents objectAtIndex:i] downloadImage];
			}
		}
		
		convertedData = true;
	}
}


void iphonenetworkApp::resize( int width, int height )
{
	mCam.lookAt( Vec3f( 3, 2, -3 ), Vec3f::zero() );
	mCam.setPerspective( 60, width / (float)height, 1, 1000 );
}

void iphonenetworkApp::mouseDown( MouseEvent event )
{
	//std::cout << "Mouse down @ " << event.getPos() << std::endl;

	
}
void iphonenetworkApp::touchesBegan( TouchEvent event ) {
	//std::vector test = event.getTouches();
	//;
	NSLog(@"Touches began x: %f y: %f",event.getTouches()[0].getX(),event.getTouches()[0].getY());
	testRadius = 1.2f;
}
void iphonenetworkApp::touchesMoved( TouchEvent event ) {
	
	//testX = ( / 384 ) ;
	//testY = ((1024 - event.getTouches()[0].getY()) / 512);
	//-1 to 1
	float y = 768 - event.getTouches()[0].getX();
	float x = event.getTouches()[0].getY();
	testY = -1 * ((x - 512)/512);
	testX = -1 * ((y - 384)/384);
	testRadius = testX + 1 + 1;
	
	NSLog(@"Touches moved x: %f y: %f",testX,testY);
	//testRadius = testX;
}
void iphonenetworkApp::touchesEnded( TouchEvent event ){
	NSLog(@"touches ended");
}


void iphonenetworkApp::update()
{
	//mCubeRotation.rotate( Vec3f( 1, 1, 1 ), 0.03f );
}



void iphonenetworkApp::draw()
{
	//NSLog(@"step 2");
	gl::setMatricesWindow( getWindowSize(), false );
	gl::enableAlphaBlending();
	gl::clear( Color( 0.5, 0.5, 0.5 ) );
	if(mapBG)
	{
		
		gl::color(ColorA(1.0f, 1.0f, 1.0f, 1.0f) );
		gl::translate(Vec3f(768.0f,1024.0f,0.0f));
		gl::rotate(Vec3f(180.0f,0.0f,0.0f));
		gl::rotate(Vec3f(0.0f,0.0f,90.0f));
		// try both ways
		gl::draw( mapBG );
		
		if( [request isFinished] ){		
			if([request hasData]){
				makeUseable();
				glPushMatrix();
				Vec2f center = getWindowCenter();
				center.normalize();
				//gl::drawSolidCircle(center,30.0f);
				for(int i = 0; i < [mFoodEvents count]; i++){
					[[mFoodEvents objectAtIndex:i] render];
				}
				glPopMatrix();
			}
		}
		//gl::draw( mapBG, Rectf( offset.x, offset.y, bounds.x, bounds.y ) );
	}
	/*
	
	gl::clear( Color( 0.2f, 0.2f, 0.3f ) );
	gl::enableDepthRead();
	
	//gl::clear();//Color(1,1,1),true
	//glColor3f(1.0f,1.0f,1.0f);
	//NSLog(@"step 3");
	
	if( [request isFinished] ){		
		if([request hasData]){
			makeUseable();
			glPushMatrix();
				gl::scale(Vec3f(0.1f,0.1f,0.1f));
				gl::scale(Vec3f(0.13f, 0.10f,0.10f));
				//gl::drawSolidCircle(Vec2f(testX*77,testY*100),1.0f);
				//NSLog(@"a: %f b: %f",testX*77,testY*9.17);
				
				glPushMatrix();
					gl::rotate(Vec3f(0,0,180.0f));
					for(int i = 0; i < [mFoodEvents count]; i++){
						[[mFoodEvents objectAtIndex:i] render];
					}
				glPopMatrix();
			glPopMatrix();

		}
	}else if( [request isFailed] ){
		
		
	}else{

	}
	glEnable(GL_TEXTURE_2D);
	//NSLog(@"step 4");
	mapBG.bind();
	glDisable(GL_TEXTURE_2D);
	//NSLog(@"step 5");
	//NSLog(@"%d", mapBG.getWidth());
	//NSLog(@"step 6");
	//glPushMatrix();
//	glEnable( GL_TEXTURE_2D );
//	//Color(0.0f, 0.0f, 0.0f);
//	//gl::scale(Vec3f(5.0f,5.0f,1.0f));
//	//gl::draw(mapBG);
//	CGRect temp;
//	temp.origin = CGPointMake(0, 0);
//	temp.size = CGSizeMake(1024, 768);
//	//[mapBGUI drawInRect:temp];
//	CGImageRef imageRef = [mapBGUI CGImage];
//	NSLog(@"test 1 %@  %@",imageRef,mapBGUI);
//	CGContextRef theContext = createWindowCgContext();
//	CGContextDrawImage(theContext, temp,imageRef );
//	NSLog(@"test 2");
//	glDisable( GL_TEXTURE_2D );
//	glPopMatrix();
	 */
}

CINDER_APP_COCOA_TOUCH( iphonenetworkApp, RendererGl )


