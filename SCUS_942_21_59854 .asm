.label @Random_Number, 0x8002230c
.label @Prep_Text_load_WORLD, 0x800e6edc
.label @Status_Flag_Check, 0x8018e9bc

										.org 0x80059854
										@Initialize_Status_Check_Data:  #ISCD  #code
0x00059854:                                      addiu r29,r29,0xffe8					  #
                                                 sw r31,0x0010(r29)					      #
                                                 lui r4,0x8006						      #
                                                 addiu r4,r4,0x9414					      #r4 = Pointer to ?
                                                 jal 0x0005e644						      #Data Nullifying
                                                 ori r5,r0,0x0080					      #Limit = 0x80
                                                 lui r4,0x8006						      #
                                                 addiu r4,r4,0x62d0					      #r4 = Pointer to Status Checks
                                                 jal 0x0005e644						      #Data Nullifying
                                                 ori r5,r0,0x0037					      #Limit = 0x37 (11 total check types)
                                                 addu r7,r0,r0						      #Current Status = 0
                                                 addu r8,r0,r0						      #Status Pointer Mod = 0
@ISCD.status_check_loop:                         lui r1,0x8006						      #
                                                 addu r1,r1,r8						      #
                                                 lbu r5,0x5de8(r1)					      #Load Status Effects Byte 4
                                                 lui r1,0x8006						      #
                                                 addu r1,r1,r8						      #
                                                 lbu r6,0x5de9(r1)					      #Load Status Effects Byte 5
                                                 bgez r7, @ISCD.skip			          #Branch if Current Status >= 0
                                                 addu r2,r7,r0						      #r2 = Current Status
                                                 addiu r2,r7,0x0007					      #r2 = Current Status + 7 (random  negative crap)
@ISCD.skip:                                      sra r4,r2,0x03						      #Current Status / 8 (rather than setting back to 0 each loop)
                                                 andi r2,r7,0x0007					      #Current Status AND 7 (get actual  status bit)
                                                 ori r3,r0,0x0080					      #r3 = 0x80
                                                 srav r3,r3,r2						      #0x80 >> Current Status (which  status to enable)
                                                 andi r2,r5,0x0001					      #
                                                 beq r2,r0, @ISCD.Not_KO			      #Branch if KO Flag isn't enabled
                                                 andi r2,r5,0x0002					      #
                                                 lui r1,0x8006						      #
                                                 addu r1,r1,r4						      #
                                                 lbu r2,0x62d0(r1)					      #Load KO Status Checks
                                                 nop								      #
                                                 or r2,r3,r2						      #Enable Current Status
                                                 lui r1,0x8006						      #
                                                 addu r1,r1,r4						      #
                                                 sb r2,0x62d0(r1)					      #Store new KO Status Checks
                                                 andi r2,r5,0x0002					      #
@ISCD.Not_KO:                                    beq r2,r0, @ISCD.x02_not_enabled	      #Branch if 0x02 isn't enabled (byte  0x04)
                                                 andi r2,r5,0x0004					      #
                                                 lui r1,0x8006						      #
                                                 addu r1,r1,r4						      #
                                                 lbu r2,0x62d5(r1)					      #Load 0x02 Status Checks
                                                 nop                                      #
                                                 or r2,r3,r2					          #Enable Current Status
                                                 lui r1,0x8006						      #
                                                 addu r1,r1,r4						      #
                                                 sb r2,0x62d5(r1)				          #Store new 0x02 Status Checks
                                                 andi r2,r5,0x0004                        #
@ISCD.x02_not_enabled:                           beq r2,r0, @ISCD.x04_not_enabled	      #Branch if 0x04 isn't enabled (byte 0x04)
                                                 andi r2,r5,0x0080                        #
                                                 lui r1,0x8006                            #
                                                 addu r1,r1,r4                            #
                                                 lbu r2,0x62da(r1)					      #Load 0x04 Status Checks
                                                 nop                                      #
                                                 or r2,r3,r2					          #Enable Current Status
                                                 lui r1,0x8006                            #
                                                 addu r1,r1,r4                            #
                                                 sb r2,0x62da(r1)					      #Store new 0x04 Status Checks
                                                 andi r2,r5,0x0080                        #
@ISCD.x04_not_enabled:                           beq r2,r0, @ISCD.Freeze_CT_skip	      #Branch if Freeze CT isn't enabled (byte  0x04)
                                                 andi r2,r6,0x0080                        #
                                                 lui r1,0x8006                            #
                                                 addu r1,r1,r4                            #
                                                 lbu r2,0x62df(r1)					      #Load 0x80 Status Checks
                                                 nop                                      #
                                                 or r2,r3,r2					          #Enable Current Status
                                                 lui r1,0x8006						      #
                                                 addu r1,r1,r4                            #
                                                 sb r2,0x62df(r1)				          #Store new 0x80 Status Checks
                                                 andi r2,r6,0x0080                        #
@ISCD.Freeze_CT_skip:                            beq r2,r0, @ISCD.cant_react_skip	      #Branch if 0x80 isn't present (byte  0x05)
                                                 andi r2,r6,0x0001                        #
                                                 lui r1,0x8006                            #
                                                 addu r1,r1,r4                            #
                                                 lbu r2,0x62e4(r1)					      #Load 0x80 Status Checks
                                                 nop                                      #
                                                 or r2,r3,r2					          #Enable Current Status
                                                 lui r1,0x8006                            #
                                                 addu r1,r1,r4                            #
                                                 sb r2,0x62e4(r1)					      #Store new 0x80 Status Checks
                                                 andi r2,r6,0x0001                        #
@ISCD.cant_react_skip:                           beq r2,r0, @ISCD.immortal_immunity_skip  #Branch if Immortal Immunity isn't  enabled
                                                 andi r2,r6,0x0002                        #
                                                 lui r1,0x8006                            #
                                                 addu r1,r1,r4                            #
                                                 lbu r2,0x62e9(r1)					      #Load Immortal Immunities
                                                 nop                                      #
                                                 or r2,r3,r2					          #Enable Current Status
                                                 lui r1,0x8006                            #
                                                 addu r1,r1,r4                            #
                                                 sb r2,0x62e9(r1)					      #Store new Immortal Immunities
                                                 andi r2,r6,0x0002                        #
@ISCD.immortal_immunity_skip:                    beq r2,r0, @ISCD.load/save_immunity_skip #Branch if Load/Save Formation  Immunities isn't enabled
                                                 andi r2,r6,0x0004                        #
                                                 lui r1,0x8006                            #
                                                 addu r1,r1,r4                            #
                                                 lbu r2,0x62ee(r1)					      #Load Load/Save Formation Immunities
                                                 nop                                      #
                                                 or r2,r3,r2						      #Enable Current Status
                                                 lui r1,0x8006                            #
                                                 addu r1,r1,r4                            #
                                                 sb r2,0x62ee(r1)					      #Store new Load/Save Formation  Immunities
                                                 andi r2,r6,0x0004                        #
@ISCD.load/save_immunity_skip:                   beq r2,r0, @ISCD.2nd_x04_not_enabled     #Branch if 0x04 isn't present (byte  0x05)
                                                 andi r2,r6,0x0008                        #
                                                 lui r1,0x8006                            #
                                                 addu r1,r1,r4                            #
                                                 lbu r2,0x62f3(r1)					      #Load 0x04 Status Checks
                                                 nop                                      #
                                                 or r2,r3,r2							  #Enable Current Status
                                                 lui r1,0x8006                            #
                                                 addu r1,r1,r4                            #
                                                 sb r2,0x62f3(r1)						  #Store new 0x04 Status Checks
                                                 andi r2,r6,0x0008                        #
@ISCD.2nd_x04_not_enabled:                       beq r2,r0, @ISCD.2nd_x08_not_enabled	  #Branch if 0x08 isn't present (byte  0x05)
                                                 andi r2,r6,0x0010                        #
                                                 lui r1,0x8006                            #
                                                 addu r1,r1,r4                            #
                                                 lbu r2,0x62f8(r1)					      #Load 0x08 Status Checks
                                                 nop                                      #
                                                 or r2,r3,r2							  #Enable Current Status
                                                 lui r1,0x8006                            #
                                                 addu r1,r1,r4                            #
                                                 sb r2,0x62f8(r1)					      #Store new 0x08 Status Chekcs
                                                 andi r2,r6,0x0010                        #
@ISCD.2nd_x08_not_enabled:                       beq r2,r0, @ISCD.2nd_x10_not_enabled	  #Branch if 0x10 isn't present (byte  0x05)
                                                 addiu r8,r8,0x0010					      #Status Pointer Mod += 0x10
                                                 lui r1,0x8006						      #
                                                 addu r1,r1,r4						      #
                                                 lbu r2,0x62fd(r1)					      #Load 0x10 Status Checks
                                                 nop									  #
                                                 or r2,r3,r2							  #Enable Current Status
                                                 lui r1,0x8006                            #
                                                 addu r1,r1,r4                            #
                                                 sb r2,0x62fd(r1)						  #Store new 0x10 Status Checks
@ISCD.2nd_x10_not_enabled:                       addiu r7,r7,0x0001					      #Current Status += 1
                                                 slti r2,r7,0x0028                        #
                                                 bne r2,r0, @ISCD.status_check_loop		  #Branch if Current Status < 40
                                                 nop                                      #hardcoded mountable status?
                                                 ori r2,r0,0x0060						  #r2 = Crystal/Dead
                                                 lui r1,0x8006                            #
                                                 sb r2,0x6302(r1)		                  #Store new Unmountable Status Checks 1
                                                 ori r2,r0,0x0085		                  #r2 = Petrify/Blood Suck/Treasure
                                                 lui r1,0x8006                            #
                                                 sb r2,0x6303(r1)		                  #Store new Unmountable Status Checks 2
                                                 ori r2,r0,0x000e		                  #r2 = Berserk/Chicken/Frog
                                                 lui r1,0x8006                            #
                                                 sb r2,0x6304(r1)		                  #Store new Unmountable Status Checks 3
                                                 ori r2,r0,0x0020		                  #r2 = Charm
                                                 lui r1,0x8006                            #
                                                 sb r2,0x6306(r1)		                  #Store new Unmountable Status Checks 5
                                                 lw r31,0x0010(r29)                       #
                                                 addiu r29,r29,0x0018                     #
                                                 jr r31                                   #
                                                 nop                                      #
#/code

                                        @Return: #Unused #code 
									            jr r31                                    #
										        nop                                       #
#/code																														  
										
										@Clear_Party:  #CP # 0x00059ac8 #code                
                                                ori r3,r0,0x00ff                          #r3 = 0xFF
                                                ori r2,r0,0x1300                          #r2 = x1300 (counter)
@CP.loop: 								    	lui r1,0x8005                             #
             									addu r1,r1,r2                             #
             									sb r3,0x7f75(r1)                          #Store Party ID as 0xFF
             									addiu r2,r2,-0x0100                       #counter - x100
             									bgez r2, @CP.loop                         #Set next unit as party id xFF
             									nop                                       #
             									jr r31                                    #
             									nop                                       #
#/code
										
										@Get_Party_Data_Pointer:  #GPDP #0x00059af0  #code 
                                                slti r2,r4,0x0014                         #
                                                beq r2,r0, @GPDP.no_unit		          #Branch if Counter >= 0x14
                                                sll r3,r4,0x08		                      #Counter * 256
                                                lui r2,0x8005                             #
                                                addiu r2,r2,0x7f74                        #r2 = Start of Party Data
                                                j @GPDP.end                               #
                                                addu r2,r3,r2		                      #Pointer = Unit Party Data Pointer
@GPDP.no_unit:                                  addu r2,r0,r0                             #Pointer = 0
@GPDP.end:                                      jr r31                                    #
                                                nop                                       #
#/code 
										
										@Unit_Initialization:   #UI  # 0x00059b18 #code 
                                                addiu r29,r29,0xfe20		              #r4 = ENTD Data Pointer (0x1dc000 data)
                                                sw r17,0x01d4(r29 )                       #
                                                addu r17,r6,r0		                      #r17 = 0 (not called with a  different value in-battle)
                                                sll r2,r5,0x02		                      #Counter * 4
                                                addu r2,r2,r5		                      #Counter * 5
                                                sll r2,r2,0x03		                      #Counter * 40
                                                addu r5,r4,r2		                      #ENTD Data Pointer + Counter * 40
                                                sw r31,0x01d8(r29)                        #
                                                sw r16,0x01d0(r29)                        #
                                                lui r1,0x8006                             #
                                                sw r5,0x6238(r1)		                  #Store Current ENTD Data Pointer
                                                lbu r2,0x0000(r5)		                  #Load Sprite Set
                                                nop                                       #
                                                beq r2,r0, @UI.no_sprite_set		      #Branch if Sprite Set = 0
                                                addu r6,r7,r0		                      #r6 = r7 (r7 is 1 in this case)
                                                addiu r16,r29,0x0010		              #r16 = Temp Unit Data
                                                addu r4,r16,r0		                      #r4 = Temp Unit Data
                                                ori r3,r0,0x00ff		                  #r3 = 0xFF
                                                ori r2,r0,0x0020		                  #r2 = 0x20
                                                sb r2,0x0011(r29)		                  #Store Unit's Unit ID = 0x20 (?)
                                                ori r2,r0,0x0001		                  #r2 = 1
                                                addu r7,r0,r0		                      #r7 = 0
                                                sb r3,0x019a(r29)		                  #Store Unit's Unit ID = FF
                                                sb r2,0x0193(r29)		                  #Store Unit's ? = 1 (Unit Exists?)
                                                jal @Unit_Battle_Initialization           #Unit Battle Initialization
                                                sb r3,0x0012(r29)		                  #Store Unit's Party ID = FF
                                                addu r4,r16,r0		                      #r4 = Temp Unit's Data Pointer
                                                jal @Add_Unit_to_Party_Data		          #Add Unit to Party/Store Unit's Party Data
                                                addu r5,r17,r0		                      #r5 = 0 (No new party members)
                                                j @UI.end                                 #
                                                nop                                       #
@UI.no_sprite_set:                              addiu r2,r0,0xfffe		                  #r2 = -2
@UI.end:                                        lw r31,0x01d8(r29)                        #
                                                lw r17,0x01d4(r29)                        #
                                                lw r16,0x01d0(r29)                        #
                                                addiu r29,r29,0x01e0                      #
                                                jr r31                                    #
                                                nop                                       #
#/code 
										
										@Add_Unit_to_Party_Data:  #AUtP # 0x00059bb0  #code 
                                                addiu r29,r29,0xffd8                    #
                                                sw r18,0x0020(r29)                      #
                                                addu r18,r4,r0		                    #r18 = Unit's Data Pointer
                                                sw r31,0x0024(r29)                      #
                                                sw r17,0x001c(r29)                      #
                                                sw r16,0x0018(r29)                      #
                                                lbu r3,0x0006(r18)		                #Load Unit's Gender Byte
                                                lbu r2,0x0000(r18)		                #Load Unit's Sprite Set
                                                nop                                     #
                                                sltiu r2,r2,0x0080					    #
                                                beq r2,r0, @AUtP.Generic_Unit           #Branch if Unit is Generic
                                                andi r3,r3,0x0001                       #r3 = Save Formation Flag
                                                bne r5,r0, @AUtP.r5_not_0               #Branch if Preset Value != 0 (Input from outer routine)
                                                nop                                     #
@AUtP.Generic_Unit:                             addu r3,r0,r0                           #r3 = 0 (No Save Formation Flag)
@AUtP.r5_not_0:                                 lbu r4,0x0002(r18)		                #Load Unit's Party ID
                                                andi r2,r3,0x00ff                       #
                                                bne r2,r0, @AUtP.save_formation		    #Branch if Unit has Save Formation Flag (and PV != 0)
                                                andi r16,r4,0x00ff		                #r16 = Unit's Party ID
                                                addiu r2,r4,0xfff0		                #r2 = Guest ID
                                                sltiu r2,r2,0x0004                      #
                                                beq r2,r0, @AUtP.not_a_guest		    #Branch if Unit isn't a Guest
                                                sltiu r2,r16,0x0015		                #(Guest joining as actual party member?)
                                                jal @Remove_Unit_from_Party		        #Remove Unit from Party
                                                nop                                     #
                                                addu r4,r0,r0		                    #r4 = 0 (Normal Party)
@AUtP.loop:                                     jal @Find_Free_Party_Slot		        #Find Free Party Slot
                                                addiu r5,r29,0x0010		                #r5 = Stack Pointer + 0x10
                                                addu r4,r2,r0		                    #r4 = Free Party Slot
                                                addiu r2,r0,0xffff                      #
                                                beq r4,r2, @AUtP.end		            #Branch if No slots are free
                                                addu r17,r4,r0		                    #r17 = Free Party Slot
                                                j @AUtP.add_unit                        #
                                                nop                                     #
@AUtP.save_formation:                           sltiu r2,r16,0x0015                     #
@AUtP.not_a_guest:                              bne r2,r0, @AUtP.find_slot              #Branch if Unit is a Party Member
                                                addu r4,r0,r0		                    #r4 = 0 (Normal Party)
                                                j @AUtP.loop		                    #(Adding new unit to party)
                                                addu r4,r3,r0		                    #r4 = Save Formation Flag (Normal if 0, Guest if 1)
@AUtP.find_slot:                                jal @Find_Free_Party_Slot		        #Find Free Party Slot (just to set stack value = 0?)
                                                addiu r5,r29,0x0010	                    #r5 = Stack Pointer
                                                addu r17,r16,r0		                    #r17 = Party ID
@AUtP.add_unit:                                 jal @Get_Party_Data_Pointer		        #Get Party Data Pointer
                                                addu r4,r17,r0		                    #r4 = Unit's Party ID
                                                lbu r3,0x0000(r18)	                    #Load Unit's Sprite Set
                                                addu r16,r2,r0		                    #r16 = Unit's Party Data Pointer
                                                sb r17,0x0001(r16)	                    #Store Unit's Party ID
                                                sb r3,0x0000(r16)		                #Store Unit's Sprite Set
                                                lbu r2,0x0003(r18)                      #Load Unit's Job ID
                                                nop                                     #
                                                sb r2,0x0002(r16)                       #Store Unit's Job ID
                                                slti r2,r17,0x0010                      #
                                                bne r2,r0, @AUtP.normal_unit		    #Branch if Unit is a Normal Party Member
                                                nop                                     #
                                                lbu r2,0x0004(r18)	                    #Load Unit's Palette
                                                nop                                     #
                                                sb r2,0x0003(r16)		                #Store Unit's Palette
                                                lbu r2,0x0006(r18)		                #Load Unit's Gender Byte
                                                j @AUtP.store_gender                    #
                                                andi r2,r2,0x00fb		                #Disable ??? stats
@AUtP.normal_unit:                              lbu r2,0x0010(r29)		                #Load Stack Value (0)
                                                nop                                     #
                                                sb r2,0x0003(r16)		                #Store Unit's Palette
                                                lbu r2,0x0006(r18)	                    #Load Unit's Gender Byte
                                                nop                                     #
                                                andi r2,r2,0x00fa		                #Disable ??? Stats and Save Formation
@AUtP.store_gender:                             sb r2,0x0004(r16)		                #Store Unit's Gender Byte
                                                addiu r4,r18,0x0013		                #r4 = Unit's Secondary Skillset Pointer
                                                addiu r5,r16,0x0007		                #r5 = Party Secondary Skillset Pointer
                                                ori r6,r0,0x0010		                #Limit = 0x10
                                                lhu r3,0x0008(r18)		                #Load Unit's Birthday + Zodiac
                                                lhu r2,0x0008(r18)		                #" (Derp)
                                                andi r3,r3,0x01ff		                #r3 = Birthday
                                                andi r2,r2,0xf000		                #r2 = Zodiac
                                                or r3,r3,r2			                    #...
                                                srl r2,r3,0x08		                    #Zodiac / 256
                                                sb r3,0x0005(r16)		                #Store Party Birthday
                                                jal 0x0005e254		                    #Store X Byte into Y (Secondary/R/S/M/Equips/Exp/Level)
                                                sb r2,0x0006(r16)		                #Store Party Zodiac
                                                addiu r4,r18,0x0072		                #r4 = Unit's Raw HP Pointer
                                                lbu r2,0x0023(r18)		                #Load Unit's Original Brave
                                                addiu r5,r16,0x0019		                #r5 = Party Raw HP Pointer
                                                sb r2,0x0017(r16)		                #Store Party Brave
                                                lbu r2,0x0025(r18)		                #Load Unit's Original Faith
                                                ori r6,r0,0x000f		                #Limit = 0xF
                                                jal 0x0005e254		                    #Store X Byte into Y (Raw Stats)
                                                sb r2,0x0018(r16)		                #Store Party Faith
                                                addiu r4,r18,0x0096		                #r4 = Unit's Unlocked Jobs Pointer
                                                addiu r5,r16,0x0028		                #r5 = Party Unlocked Jobs Pointer
                                                jal 0x0005e254		                    #Store X Byte into Y (Job Data)
                                                ori r6,r0,0x00a6		                #Limit = 0xa6
                                                lbu r2,0x016c(r18)		                #Load Unit's Name ID
                                                nop                                     #
                                                sb r2,0x00ce(r16)		                #Store Party Name ID
                                                lhu r3,0x016c(r18)		                #Load Unit's Name ID
                                                addu r2,r0,r0		                    #r2 = 0
                                                sb r0,0x00d0(r16)		                #Store ? = 0
                                                sb r0,0x00d2(r16)		                #Store ? = 0
                                                srl r3,r3,0x08                          #
                                                sb r3,0x00cf(r16)		                #Store Party Name ID High bit
@AUtP.end:                                      lw r31,0x0024(r29)                      #
                                                lw r18,0x0020(r29)                      #
                                                lw r17,0x001c(r29)                      #
                                                lw r16,0x0018(r29)                      #
                                                addiu r29,r29,0x0028                    #
                                                jr r31                                  #
                                                nop                                     #
#/code 												
												
										
										@Find_Free_Party_Slot:   #FFPS # 0x00059d5c #code
                                                addiu r29,r29,0xff90                    #
                                                sw r18,0x0068(r29)                      #
                                                addu r18,r4,r0		                    #r18 = Save Formation Flag
                                                sw r16,0x0060(r29)                      #
                                                addu r16,r0,r0		                    #Counter = 0
                                                sw r17,0x0064(r29)                      #
                                                addiu r17,r29,0x0010		            #r17 = Stack Pointer + 0x10
                                                sw r31,0x006c(r29)                      #
                                                sb r0,0x0000(r5)                        #Store Stack Value = 0
@FFPS.loop:                                     jal @Get_Party_Data_Pointer		        #Get Party Data Pointer
                                                addu r4,r16,r0		                    #r4 = Counter
                                                sw r2,0x0000(r17)		                #Store Party Data Pointer
                                                addiu r16,r16,0x0001		            #Counter ++
                                                slti r2,r16,0x0014                      #
                                                bne r2,r0, @FFPS.loop		            #Branch if Counter < 0x14 (loop 20 times)
                                                addiu r17,r17,0x0004		            #Stack Pointer += 4
                                                beq r18,r0, @FFPS.no_save_formation	    #Branch if Unit doesn't have Save Formation Flag
                                                ori r2,r0,0x0010		                #Party Counter = 0x10 (Guests)
                                                j @FFPS.pointers_saved                  #
                                                ori r5,r0,0x0014		                #Limit = 0x14
@FFPS.no_save_formation:                        addu r2,r0,r0		                    #Party Counter = 0
                                                ori r5,r0,0x0010                        #Limit = 0x10
@FFPS.pointers_saved:                           addu r16,r2,r0		                    #r16 = Party Counter
                                                slt r2,r16,r5                           #
                                                beq r2,r0, @FFPS.no_slot_available		#Branch if Party Counter >= Limit
                                                sll r2,r16,0x02		                    #Party Counter * 4
                                                ori r4,r0,0x00ff		                #r4 = FF
                                                addiu r3,r29,0x0010		                #r3 = Stack Pointer + 0x10
                                                addu r3,r2,r3                           #
@FFPS.loop_find_slot:                           lw r2,0x0000(r3)		                #Load Unit's Party Data Pointer
                                                nop                                     #
                                                lbu r2,0x0001(r2)		                #Load Unit's Party ID
                                                nop                                     #
                                                beq r2,r4, @FFPS.end                    #Branch if unit doesn't exist
                                                addu r2,r16,r0		                    #Free Party ID = Party Counter
                                                addiu r16,r16,0x0001		            #Party Counter ++
                                                slt r2,r16,r5                           #
                                                bne r2,r0, @FFPS.loop_find_slot		    #Branch if Party Counter < Limit (loop 20 times)
                                                addiu r3,r3,0x0004		                #Stack Pointer += 4
@FFPS.no_slot_available:                        addiu r2,r0,0xffff		                #Free Party ID = None
@FFPS.end:                                      lw r31,0x006c(r29)                      #
                                                lw r18,0x0068(r29)                      #
                                                lw r17,0x0064(r29)                      #
                                                lw r16,0x0060(r29)                      #
                                                addiu r29,r29,0x0070                    #
                                                jr r31                                  #
                                                nop							            #
#/code
										
										@Create_Monster_Egg:  #CME  #code                #WORLD.bin only
                                                addiu r29,r29,0xffd8                     #
                                                sw r19,0x001c(r29)                       #
                                                addu r19,r4,r0		                     #r19 = Monster Job ID
                                                sw r16,0x0010(r29)                       #
                                                addu r16,r5,r0		                     #r16 = Egg Mod (used as birthday)
                                                sw r20,0x0020(r29)                       #
                                                addu r20,r6,r0		                     #r20 = Random (rand(0..3))
                                                ori r4,r0,0x0003		                 #Unit Type = Monster
                                                sw r31,0x0024(r29)                       #
                                                sw r18,0x0018(r29)                       #
                                                jal @Find_Empty_Party_Slot_Generate_Unit #Find Empty Party Slot and Generate Unit
                                                sw r17,0x0014(r29)                       #
                                                addu r18,r2,r0		                     #r18 = Party ID
                                                addiu r2,r0,0xffff                       #
                                                beq r18,r2, @CME.end                     #Branch if there is no space left
                                                nop							             #
                                                jal @Get_Party_Data_Pointer		         #Get Party Data Pointer
                                                addu r4,r18,r0		                     #r4 = Party ID
                                                addu r17,r2,r0		                     #r17 = Party Data Pointer
                                                lbu r2,0x0004(r17)		                 #Load Party Gender Byte
                                                sb r19,0x0002(r17)		                 #Store Job ID
                                                sb r20,0x00d2(r17)		                 #Store ? = Random
                                                ori r2,r2,0x0004                         #
                                                sb r2,0x0004(r17)		                 #Store Gender with ??? Stats (Egg) Enabled
                                                andi r2,r16,0xffff                       #
                                                sltiu r2,r2,0x016e                       #
                                                bne r2,r0, @CME.skip                     #Branch if Egg Mod < 0x16e
                                                nop                                      #
                                                ori r16,r0,0x0001		                 #r16 = 1
@CME.skip:                                      jal 0x0005e5d8		                     #Calculate Zodiac Symbol
                                                andi r4,r16,0xffff	                     #r4 = Egg Mod
                                                sll r4,r2,0x04		                     #Zodiac * 16
                                                addu r2,r18,r0		                     #r2 = Party ID
                                                andi r3,r16,0x0100		                 #Egg Mod High Bit (not needed; just generic date code)
                                                srl r3,r3,0x08		                     #High Bit / 256
                                                addu r3,r3,r4                            #High Bit + Zodiac
                                                sb r16,0x0005(r17)		                 #Store Birthday = Egg Mod
                                                sb r3,0x0006(r17)                        #Store Zodiac (useless?)
@CME.end:                                       lw r31,0x0024(r29)                       #
                                                lw r20,0x0020(r29)                       #
                                                lw r19,0x001c(r29)                       #
                                                lw r18,0x0018(r29)                       #
                                                lw r17,0x0014(r29)                       #
                                                lw r16,0x0010(r29)                       #
                                                addiu r29,r29,0x0028                     #
                                                jr r31                                   #
                                                nop							             #
#/code 

										
										@Find_Empty_Party_Slot_Generate_Unit:  #FSGU # 0x00059ed4 #code #WORLD.BIN only
                                                addiu r29,r29,0xff88                     #
                                                sw r18,0x0068(r29)                       #
                                                addu r18,r4,r0		                     #r18 = Unit Type
                                                sw r19,0x006c(r29)                       #
                                                addu r19,r0,r0		                     #Palette = 0
                                                sw r16,0x0060(r29)                       #
                                                addu r16,r0,r0		                     #Counter = 0
                                                sw r17,0x0064(r29)                       #
                                                addiu r17,r29,0x0010                     #r17 = Stack Pointer
                                                sw r31,0x0070(r29)                       #
@FSGU.loop:                                     jal @Get_Party_Data_Pointer		         #Get Party Data Pointer
                                                addu r4,r16,r0		                     #r4 = Counter
                                                sw r2,0x0000(r17)		                 #Temp Store Party Data Pointer
                                                addiu r16,r16,0x0001	                 #Counter ++
                                                slti r2,r16,0x0014		                 #(doesn't need limit of 0x14)
                                                bne r2,r0, @FSGU.loop	                 #Branch if Counter < 0x14
                                                addiu r17,r17,0x0004	                 #Stack Pointer += 4
                                                addu r16,r0,r0		                     #Counter = 0
                                                ori r5,r0,0x00ff		                 #r5 = FF
                                                addiu r4,r29,0x0010		                 #r4 = Stack Pointer
@FSGU.2nd_loop:                                 lw r3,0x0000(r4)		                 #Load Party Data Pointer
                                                nop                                      #
                                                lbu r2,0x0001(r3)		                 #Load Party ID
                                                nop                                      #
                                                bne r2,r5, @FSGU.unit_exist	             #Branch if Unit exists
                                                nop                                      #
                                                sb r16,0x0001(r3)		                 #Store Party ID = Counter
                                                lw r2,0x0000(r4)		                 #Load Party Data Pointer
                                                nop                                      #
                                                sb r19,0x0003(r2)		                 #Store Palette = 0
                                                lw r4,0x0000(r4)		                 #Load Party Data Pointer
                                                jal @Out_of_Battle_Unit_Generation		 #Out of Battle Unit Generation
                                                addu r5,r18,r0		                     #r5 = Unit Type
                                                j @FSGU.end                              #
                                                addu r2,r16,r0		                     #Party ID = Counter
@FSGU.unit_exist:                               addiu r16,r16,0x0001		             #Counter ++
                                                slti r2,r16,0x0010                       #
                                                bne r2,r0, @FSGU.2nd_loop		         #Branch if Counter < 0x10
                                                addiu r4,r4,0x0004		                 #Stack Pointer += 4
                                                addiu r2,r0,0xffff		                 #Party ID = None
@FSGU.end:                                      lw r31,0x0070(r29)                       #
                                                lw r19,0x006c(r29)                       #
                                                lw r18,0x0068(r29)                       #
                                                lw r17,0x0064(r29)                       #
                                                lw r16,0x0060(r29)                       #
                                                addiu r29,r29,0x0078                     #
                                                jr r31					                 #
                                                nop                                      #
#/code 

										
										@Find_Unit_Party_Data_Location:  #FPDL # 0x00059f94  #code 
                                                addu r5,r0,r0		                     #Counter = 0
                                                ori r6,r0,0x00ff		                 #r6 = FF
                                                lui r3,0x8005                            #
                                                addiu r3,r3,0x7f74		                 #r3 = Party Data Pointer
@FPDL.loop:                                     lbu r2,0x0001(r3)		                 #Load Unit's Party ID
                                                nop                                      #
                                                beq r2,r6, @FPDL.unit_doesnt_exist		 #Branch if Unit doesn't exist
                                                nop                                      #
                                                lbu r2,0x0000(r3)		                 #Load Unit's Sprite Set
                                                nop                                      #
                                                beq r2,r4, @FPDL.end	                 #Branch if Sprite Set = ENTD Sprite Set
                                                addu r2,r5,r0		                     #Party ID = Counter
@FPDL.unit_doesnt_exist:                        addiu r5,r5,0x0001		                 #Counter ++
                                                slti r2,r5,0x0014                        #
                                                bne r2,r0, @FPDL.loop	                 #Branch if Counter < 20
                                                addiu r3,r3,0x0100		                 #Party Data Pointer += 0x100
                                                addiu r2,r0,0xffff		                 #Party ID = FFFF (unit doesn't exist)
@FPDL.end:                                      jr r31                                   #
                                                nop                                      #
#/code 

										
										@Remove_Unit_from_Party:  #RUFP  # 0x00059fe0 #code 
                                                sll r4,r4,0x08		                     #ID * 256
                                                ori r2,r0,0x00ff		                 #r2 = FF
                                                lui r1,0x8005                            #
                                                addu r1,r1,r4                            #
                                                sb r2,0x7f75(r1)		                 #Store Unit's Party ID = FF
                                                jr r31                                   #
                                                nop                                      #
#/code
 												
                                        
										@Out_of_Battle_Unit_Generation:  #OBUG # 0x00059ffc #code    #WORLD.BIN Only
                                                addiu r29,r29,0xffc8                     #
                                                sw r18,0x0018(r29)                       #
                                                addu r18,r4,r0		                     #r18 = Party Data Pointer
                                                sw r21,0x0024(r29)                       #
                                                addu r21,r5,r0		                     #r21 = Unit Type
                                                sw r31,0x0034(r29)                       #
                                                sw r30,0x0030(r29)                       #
                                                sw r23,0x002c(r29)                       #
                                                sw r22,0x0028(r29)                       #
                                                sw r20,0x0020(r29)                       #
                                                sw r19,0x001c(r29)                       #
                                                sw r17,0x0014(r29)                       #
                                                bne r21,r0, @OBUG.not_male	             #Branch if Not creating a male
                                                sw r16,0x0010(r29)                       #
                                                ori r23,r0,0x4100		                 #Name Flags = 0x4100
                                                ori r22,r0,0x0100		                 #Name Modifier = 0x100
                                                ori r2,r0,0x0080		                 #Sprite Set = Generic Male (Gender = Male)
                                                j @OBUG.store_gender                     #
                                                sb r2,0x0000(r18)		                 #Store Party Sprite Set
@OBUG.not_male:                                 ori r2,r0,0x0001                         #
                                                bne r21,r2, @OBUG.not_female	         #Branch if Not creating a Female
                                                ori r23,r0,0x4200		                 #Name Flags = 0x4200
                                                ori r22,r0,0x0200		                 #Name Modifier = 0x200
                                                ori r2,r0,0x0081		                 #Sprite Set = Generic Female
                                                sb r2,0x0000(r18)		                 #Store Party Sprite Set
                                                j @OBUG.store_gender                     #
                                                ori r2,r0,0x0040		                 #Gender = Female
@OBUG.not_female:                               ori r2,r0,0x0003                         #
                                                bne r21,r2, @OBUG.not_monster	         #Branch if Not creating a Monster
                                                ori r23,r0,0x4000		                 #Name Flags = 0x4000
                                                ori r23,r0,0x4300		                 #Name Flags = 0x4300
                                                ori r22,r0,0x0300		                 #Name Modifier = 0x300
                                                ori r2,r0,0x0082		                 #Sprite Set = Monster
                                                sb r2,0x0000(r18)		                 #Store Party Sprite Set
                                                ori r2,r0,0x0020		                 #Gender = Monster
@OBUG.store_gender:                             sb r2,0x0004(r18)		                 #Store Party Gender Byte
                                                ori r2,r0,0x004a                         #
                                                j @OBUG.ramza_start                      #
                                                sb r2,0x0002(r18)		                 #Store Job ID = Squire
@OBUG.not_monster:                              ori r21,r0,0x0002		                 #Unit Type = Ramza
                                                addu r22,r0,r0		                     #Name Modifier = 0
                                                ori r3,r0,0x0001		                 #Sprite Set/Job ID = C1 Ramza
                                                ori r2,r0,0x0080		                 #Gender = Male
                                                sb r3,0x0000(r18)		                 #Store Party Sprite Set
                                                sb r2,0x0004(r18)		                 #Store Party Gender Byte
                                                sb r3,0x0002(r18)		                 #Store Party Job ID
@OBUG.ramza_start:                              jal @Random_Number		                 #Random Number Generator
                                                nop                                      #
                                                sll r3,r2,0x03		                     #Random * 8
                                                addu r3,r3,r2		                     #Random * 9
                                                sll r3,r3,0x03		                     #Random * 72
                                                addu r3,r3,r2		                     #Random * 73
                                                sll r2,r3,0x02		                     #Random * 292
                                                addu r3,r3,r2		                     #Random * 365
                                                bgez r3, @OBUG.positive_result           #Branch if Random is positive
                                                sra r16,r3,0x0f		                     #rand(0..364)
                                                addiu r3,r3,0x7fff                       #
                                                sra r16,r3,0x0f                          #
@OBUG.positive_result:                          addiu r16,r16,0x0001		             #rand(0..364) + 1 (random birthday)
                                                addu r17,r16,r0		                     #r17 = Birthday
                                                jal 0x0005e5d8		                     #Calculate Zodiac Symbol
                                                andi r4,r17,0xffff	                     #r4 = Birthday
                                                sll r2,r2,0x04		                     #Zodiac * 16
                                                andi r16,r16,0x0100	                     #r16 = Birthday High Bit
                                                srl r16,r16,0x08	                     #High Bit / 256
                                                addu r16,r16,r2		                     #Zodiac + High Bit
                                                ori r2,r0,0x0002		                 #
                                                sb r17,0x0005(r18)		                 #Store Party Birthday
                                                bne r21,r2, @OBUG.not_ramza	             #Branch if Unit Type != Ramza
                                                sb r16,0x0006(r18)		                 #Store Party Zodiac
                                                ori r2,r0,0x0046		                 #Brave/Faith = 70
                                                j @OBUG.create_stats                     #
                                                sb r2,0x0017(r18)		                 #Store Party Brave
@OBUG.not_ramza:                                jal @Random_Number		                 #Random Number Generator
                                                nop                                      #
                                                sll r3,r2,0x05		                     #Random * 32
                                                subu r2,r3,r2		                     #Random * 31
                                                bgez r2, @OBUG.2nd_positive_result	                     #Branch if Random is positive
                                                nop                                      #
                                                addiu r2,r2,0x7fff                       #
@OBUG.2nd_positive_result:                      sra r2,r2,0x0f		                     #rand(0..30)
                                                addiu r2,r2,0x0028	                     #Brave = 40 + rand(0..30)
                                                jal @Random_Number	                     #Random Number Generator
                                                sb r2,0x0017(r18)	                     #Store Party Brave
                                                sll r3,r2,0x05		                     #Random * 32
                                                subu r2,r3,r2		                     #Random * 31
                                                bgez r2, @OBUG.3rd_positive_result       #Branch if Random is positive
                                                nop                                      #
                                                addiu r2,r2,0x7fff                       #
@OBUG.3rd_positive_result:                      sra r2,r2,0x0f		                     #rand(0..30)
                                                addiu r2,r2,0x0028	                     #Faith = 40 + rand(0..30)
@OBUG.create_stats:                             sb r2,0x0018(r18)	                     #Store Party Faith
                                                addiu r4,r18,0x0007	                     #r4 = Party Secondary Skillset Pointer
                                                jal 0x0005e644		                     #Data Nullifying (Secondary/R/S/M/Helm/Armor/Accessory)
                                                ori r5,r0,0x0007	                     #Limit = 7
                                                addu r4,r18,r0		                     #r4 = Party Data Pointer
                                                jal @Generate_Base_Raw_Stats_Prep_WORLD  #Generate Unit's Base Raw Stats Prep (Useless Prep)
                                                addu r5,r21,r0		                     #r5 = Unit Type
                                                addiu r4,r18,0x0028		                 #r4 = Party Unlocked Jobs
                                                ori r5,r0,0x0096		                 #Limit = 0x96
                                                ori r2,r0,0x0001		                 #Level
                                                sb r2,0x0016(r18)		                 #Store Level
                                                jal 0x0005e644		                     #Data Nullifying
                                                sb r0,0x0015(r18)		                 #Store Experience = 0
                                                lbu r19,0x0004(r18)		                 #Load Party Gender
                                                nop                                      #
                                                andi r2,r19,0x00c0                       #
                                                beq r2,r0, @OBUG.genderless	             #Branch if Unit doesn't have a Gender
                                                andi r2,r19,0x0080                       #
                                                addu r16,r0,r0		                     #Current Job = 0
                                                ori r20,r0,0x0011		                 #r20 = 0x11 (doubles as job levels)
                                                addu r17,r18,r0		                     #r17 = Party Data Pointer
@OBUG.job_loop:                                 bne r16,r20, @OBUG.not_bard	             #Branch if Current Job != Bard
                                                ori r2,r0,0x0012		                 #r2 = 0x12
                                                andi r2,r19,0x0040                       #
                                                bne r2,r0, @OBUG.no_jp_store	         #Branch if Unit is a Female
                                                ori r2,r0,0x0012                         #
@OBUG.not_bard:                                 bne r16,r2, @OBUG.not_dancer	         #Branch if Current Job != Dancer
                                                andi r2,r19,0x0080                       #
                                                bne r2,r0, @OBUG.no_jp_store		     #Branch if Unit is a Male
                                                nop                                      #
@OBUG.not_dancer:                               jal @Random_Number		                 #Random Number Generator
                                                nop                                      #
                                                sll r3,r2,0x01		                     #Random * 2
                                                addu r3,r3,r2		                     #Random * 3
                                                sll r3,r3,0x03		                     #Random * 24
                                                addu r3,r3,r2		                     #Random * 25
                                                sll r2,r3,0x02		                     #Random * 100
                                                bgez r2, @OBUG.4th_positive_result		 #Branch if Random is positive
                                                nop                                      #
                                                addiu r2,r2,0x7fff                       #
@OBUG.4th_positive_result:                      sra r2,r2,0x0f		                     #rand(0..99)
                                                addiu r2,r2,0x0064		                 #JP = 100 + rand(0..99)
                                                sb r2,0x0096(r17)		                 #Store Party Total JP
                                                sb r2,0x006e(r17)		                 #Store Party Current JP
                                                srl r2,r16,0x1f                          #
                                                addu r2,r16,r2                           #
                                                sra r2,r2,0x01		                     #Current Job / 2
                                                addu r2,r18,r2                           #
                                                sb r20,0x0064(r2)		                 #Store Party Job Levels = 1
@OBUG.no_jp_store:                              addiu r16,r16,0x0001		             #Current Job ++
                                                slti r2,r16,0x0014                       #
                                                bne r2,r0, @OBUG.job_loop		         #Branch if Current Job < 0x14
                                                addiu r17,r17,0x0002		             #JP Pointer += 2
                                                andi r2,r19,0x0080		                 #
@OBUG.genderless:                               beq r2,r0, @OBUG.2nd_not_male		     #Branch if Unit isn't a Male
                                                ori r2,r0,0x0001		                 #Dancer Level = 0; Mime = 1
                                                sb r2,0x006d(r18)		                 #Store Dancer/Mime Level
@OBUG.2nd_not_male:                             andi r2,r19,0x0040                       #
                                                beq r2,r0, @OBUG.2nd_not_female		     #Branch if Unit isn't a Female
                                                addu r16,r0,r0		                     #Counter = 0
                                                ori r2,r0,0x0010		                 #Calculator = 1; Bard = 0
                                                sb r2,0x006c(r18)		                 #Store Calculator/Bard Level
@OBUG.2nd_not_female:                           lui r3,0x8006                            #
                                                addiu r3,r3,0xe90c                       #
                                                sll r2,r21,0x01		                     #Unit Type * 2
                                                addu r2,r2,r21		                     #Type * 3
                                                sll r2,r2,0x02		                     #Type * 12
                                                addu r5,r2,r3		                     #r5 = Type's Base Data Pointer
                                                lbu r4,0x0000(r18)		                 #Load Party Sprite Set
                                                ori r2,r0,0x0080		                 #Unlocked Jobs = Base
                                                sb r2,0x0028(r18)		                 #Store Unlocked Jobs
                                                srl r2,r4,0x07		                     #Sprite Set / 128
                                                subu r2,r0,r2		                     #r2 = -(Sprite Set / 128)
                                                and r4,r4,r2                             #Generic Name ID = Sprite Set - Sprite Set / 128 (or AND 0x7f)
@OBUG.equip_loop:                               addu r3,r18,r16		                     #r3 = Party Data Pointer + Counter
                                                addu r2,r5,r16		                     #r2 = Base Data Pointer + Counter
                                                lbu r2,0x0005(r2)		                 #Load Base Equipment
                                                addiu r16,r16,0x0001		             #Counter ++
                                                sb r2,0x000e(r3)		                 #Store Party Equipment
                                                slti r2,r16,0x0007                       #
                                                bne r2,r0, @OBUG.equip_loop		         #Branch if Counter < 7
                                                ori r2,r0,0x0002                         #
                                                bne r21,r2, @OBUG.2nd_not_ramza	         #Branch if Unit Type != Ramza
                                                srl r3,r22,0x08		                     #r3 = Name Modifier / 256
                                                j @OBUG.store_name                       #
                                                ori r5,r0,0x0001		                 #Chosen Name = 1 (Ramza)
@OBUG.2nd_not_ramza:                            lui r30,0x8005                           #
                                                addiu r30,r30,0x7f74	                 #	r30 = Party Data Pointer
                                                ori r20,r0,0x00ff		                 #r20 = FF
                                                andi r19,r4,0x00ff		                 #r19 = Generic Name ID
                                                ori r2,r0,0x00ff		                 #r2 = FF
                                                sb r2,0x00ce(r18)		                 #Store Unit's Name ID = Default (never used?)
                                                sb r3,0x00cf(r18)		                 #Store Unit's Name ID high bit = Name Mod / 256
@OBUG.find_new_name:                            jal @Random_Number		             #Random Number Generator
                                                ori r17,r0,0x0001		                 #r17 = 1 (Use Chosen Name)
                                                sll r3,r2,0x08		                     #Random * 256
                                                subu r2,r3,r2		                     #Random * 255
                                                bgez r2, @OBUG.5th_positive_result		 #Branch if Random is positive
                                                addu r16,r0,r0		                     #Counter = 0
                                                addiu r2,r2,0x7fff                       #
@OBUG.5th_positive_result:                      sra r2,r2,0x0f		                     #rand(0..254)
                                                addu r5,r22,r2		                     #Chosen Name ID = Name Modifier + rand(0..254)
                                                andi r6,r5,0xffff	                     #r6 = Chosen Name ID
                                                addu r4,r30,r0		                     #r4 = Party Data Pointer
@OBUG.name_inner_loop:                          lbu r2,0x0001(r4)	                     #Load Party ID
                                                nop                                      #
                                                beq r2,r20, @OBUG.name_loop_increase     #Branch if unit doesn't exist
                                                nop                                      #
                                                lbu r3,0x0000(r4)		                 #Load Party Sprite Set
                                                nop                                      #
                                                srl r2,r3,0x07                           #
                                                subu r2,r0,r2                            #
                                                and r3,r3,r2			                 #r3 = Generic Name ID
                                                bne r3,r19, @OBUG.name_loop_increase     #Branch if Generic Name ID's differ
                                                nop                                      #
                                                lbu r2,0x00cf(r4)		                 #Load Party Name ID High Bit
                                                lbu r3,0x00ce(r4)		                 #Load Party Name ID
                                                sll r2,r2,0x08		                     #High Bit * 256
                                                or r3,r3,r2			                     #r3 = Name ID
                                                bne r3,r6, @OBUG.name_loop_increase      #Branch if Chosen Name isn't already used
                                                nop                                      #
                                                j @OBUG.name_start_over                  #
                                                addu r17,r0,r0		                     #r17 = 0 (Re-roll Name)
@OBUG.name_loop_increase:                       addiu r16,r16,0x0001		             #Counter ++
                                                slti r2,r16,0x0010                       #
                                                bne r2,r0, @OBUG.name_inner_loop         #Branch if Counter < 0x10
                                                addiu r4,r4,0x0100		                 #Party Pointer += 0x100
@OBUG.name_start_over:                          beq r17,r0, @OBUG.find_new_name	         #Loop if Name already exists
                                                nop                                      #
@OBUG.store_name:                               srl r2,r5,0x08                           #Chosen Name / 256
                                                andi r4,r5,0x00ff		                 #r4 = Chosen Name
                                                addu r4,r23,r4		                     #r4 = Name Flags + Chosen Name
                                                sb r5,0x00ce(r18)		                 #Store Party Name ID
                                                jal @Prep_Text_load_WORLD                #Prep for Loading Text (world)
                                                sb r2,0x00cf(r18)		                 #Store Party Name ID High Bit
                                                addu r4,r2,r0		                     #r4 = Chosen Name
                                                addiu r5,r18,0x00be		                 #r5 = Party Name Pointer
                                                jal @Store_X_into_Y                      #Store X into Y (Unit's Name)
                                                ori r6,r0,0x0010		                 #Limit = 0x10
                                                ori r2,r0,0x0002		                 #r2 = 2
                                                sb r0,0x00d0(r18)		                 #Store ? = 0
                                                bne r21,r2, @OBUG.3rd_not_ramza          #Branch if Unit Type != Ramza
                                                sb r0,0x00d2(r18)		                 #Store ? = 0
                                                ori r2,r0,0x0004		                 #Known Abilities = Wish
                                                sb r2,0x002b(r18)		                 #Store Base Known Abilities
@OBUG.3rd_not_ramza:                            lw r31,0x0034(r29)                       #
                                                lw r30,0x0030(r29)                       #
                                                lw r23,0x002c(r29)                       #
                                                lw r22,0x0028(r29)                       #
                                                lw r21,0x0024(r29)                       #
                                                lw r20,0x0020(r29)                       #
                                                lw r19,0x001c(r29)                       #
                                                lw r18,0x0018(r29)                       #
                                                lw r17,0x0014(r29)                       #
                                                lw r16,0x0010(r29)                       #
                                                addiu r29,r29,0x0038                     #
                                                jr r31                                   #
                                                nop                                      #
#/code 	


										@Generate_Base_Raw_Stats_Prep_WORLD:  #RSPW # 0x0005a3e0 #code
                                                addiu r29,r29,0xffe8		             #(USEFUL SECTION IS USEFUL)
                                                sw r31,0x0010(r29)                       #
                                                jal @Generate_Base_Raw_Stats		     #Generate Unit's Base Raw Stats
                                                addiu r4,r4,0x0019		                 #r4 = Party Raw HP Pointer
                                                lw r31,0x0010(r29)                       #
                                                addiu r29,r29,0x0018                     #
                                                jr r31                                   #
                                                nop                                      #
#/code

										@Generate_Base_Raw_Stats_Prep_BATTLE: #RSPB # 0x0005a400 #code
                                                addiu r29,r29,0xffe8                     #
                                                sw r31,0x0010(r29)                       #
                                                lbu r3,0x0006(r4)		                 #Load Unit's Gender Byte
                                                nop                                      #
                                                andi r2,r3,0x0080                        #
                                                beq r2,r0, @RSPB.not_male		         #Branch if Unit isn't a Male
                                                andi r2,r3,0x0040                        #
                                                j @RSPB.generate_stats                   #
                                                addu r5,r0,r0		                     #r5 = 0 (Male)
@RSPB.not_male:                                 beq r2,r0, @RSPB.generate_stats          #Branch if Unit isn't a Female
                                                ori r5,r0,0x0003		                 #r5 = 3 (Monster)
                                                ori r5,r0,0x0001		                 #r5 = 1 (Female)
@RSPB.generate_stats:                           jal @Generate_Base_Raw_Stats             #Generate Unit's Base Raw Stats
                                                addiu r4,r4,0x0072		                 #r4 = Pointer to Unit's Raw HP
                                                lw r31,0x0010(r29)                       #
                                                addiu r29,r29,0x0018                     #
                                                jr r31                                   #
                                                nop                                      #
#/code

										@Generate_Base_Raw_Stats:  #GBRS # 0x0005a448 #code
                                                addiu r29,r29,0xffd0                     #
                                                sw r20,0x0020(r29)                       #
                                                addu r20,r5,r0		                     #r20 = Gender Value
                                                sw r18,0x0018(r29)                       #
                                                addu r18,r0,r0		                     #Counter = 0
                                                sw r21,0x0024(r29)                       #
                                                lui r21,0x8006                           #
                                                addiu r21,r21,0xe93c                     #r21 = Base Raw Random Mod Pointer
                                                sw r17,0x0014(r29)                       #
                                                addu r17,r4,r0		                     #r17 = Unit's Data Pointer
                                                lui r3,0x8006                            #
                                                addiu r3,r3,0xe90c	                     #r3 = Base Raw Stat Pointer
                                                sll r2,r20,0x01		                     #Gender Value * 2
                                                addu r2,r2,r20		                     #Gender Value * 3
                                                sll r2,r2,0x02		                     #Gender Value * 12
                                                sw r19,0x001c(r29)                       #
                                                addu r19,r2,r3                           #
                                                sw r31,0x0028(r29)                       #
                                                sw r16,0x0010(r29)                       #
@GBRS.loop:                                     lbu r16,0x0000(r19)		                 #Load Raw Stat Mod
                                                jal @Random_Number		                 #Random Number Generator
                                                sll r16,r16,0x0e		                 #Mod * 16384
                                                sll r3,r20,0x02		                     #Gender Value * 4
                                                addu r3,r3,r20		                     #Gender Value * 5
                                                addu r3,r3,r21                           #
                                                addu r3,r3,r18                           #
                                                lbu r3,0x0000(r3)		                 #Load Raw Random Mod
                                                nop                                      #
                                                mult r2,r3			                     # Random * Mod
                                                addiu r19,r19,0x0001                     # Raw Pointer ++
                                                addiu r18,r18,0x0001                     # Counter ++
                                                mflo r2			                         # r2 = Random * Mod
                                                srl r3,r2,0x1f                           #
                                                addu r2,r2,r3                            #
                                                sra r2,r2,0x01                           #Mod Bonus = rand(0..Mod*16384 - 1)
                                                addu r16,r16,r2                          #Base Raw = Raw + Mod Bonus
                                                srl r2,r16,0x08                          #Base Raw / 256
                                                sb r16,0x0000(r17)		                 #Store Raw Stat Byte 1
                                                sra r16,r16,0x10		                 #Base Raw / 65536
                                                sb r2,0x0001(r17)		                 #Store Raw Stat Byte 2
                                                sb r16,0x0002(r17)		                 #Store Raw Stat Byte 3
                                                slti r2,r18,0x0005                       #
                                                bne r2,r0, @GBRS.loop		             #Branch if Counter < 5
                                                addiu r17,r17,0x0003		             #Unit's Raw Stat Pointer ++
                                                lw r31,0x0028(r29)                       #
                                                lw r21,0x0024(r29)                       #
                                                lw r20,0x0020(r29)                       #
                                                lw r19,0x001c(r29)                       #
                                                lw r18,0x0018(r29)                       #
                                                lw r17,0x0014(r29)                       #
                                                lw r16,0x0010(r29)                       #
                                                addiu r29,r29,0x0030                     #
                                                jr r31                                   #
                                                nop                                      #
#/code

										@Transfer_Job_Stats_to_Unit: #TJSU # 0x0005a520 #code
                                                addiu r29,r29,0xffe8                     #
                                                addu r5,r4,r0                            #r5 = Unit's Data Pointer
                                                sw r31,0x0010(r29)                       #
                                                lbu r2,0x0003(r5)		                 #Load Unit's Job ID
                                                addiu r5,r5,0x0081		                 #r5 = Unit's HP Growth Pointer
                                                ori r6,r0,0x000a		                 #Limit = 10
                                                sll r4,r2,0x01		                     #ID * 2
                                                addu r4,r4,r2		                     #ID * 3
                                                lui r2,0x8006                            #
                                                lw r2,0x6194(r2)		                 #Load Job Data Pointer
                                                sll r4,r4,0x04		                     #ID * 48
                                                addu r4,r4,r2                            #
                                                jal 0x0005e254		                     #Store X Byte into Y (Stat Growths/Multipliers)
                                                addiu r4,r4,0x000d		                 #r4 = Job's HP Growth Pointer
                                                lw r31,0x0010(r29)                       #
                                                addiu r29,r29,0x0018                     #
                                                jr r31                                   #
                                                nop                                      #
#/code

										@Load_Ability_From_Skillset: #LAFS # 0x0005a568  #code
                                                slti r2,r4,0x00b0		                 #
                                                beq r2,r0, @LAFS.is_a_monster            #Branch if using a monster skillset
                                                slti r2,r5,0x0016                        #
                                                beq r2,r0, @LAFS.return_fail_end         #Branch if Counter >= 0x16
                                                addu r6,r5,r0		                     #r6 = Counter
                                                lui r3,0x8006                            #
                                                addiu r3,r3,0x4a94                       #
                                                sll r2,r4,0x01		                     #ID * 2
                                                addu r2,r2,r4		                     #ID * 3
                                                sll r2,r2,0x03		                     #ID * 24
                                                addu r2,r2,r4		                     #ID * 25
                                                bgez r5, @LAFS.not_1st_skill             #Branch if Counter >= 0
                                                addu r4,r2,r3		                     #r4 = Pointer to Skillsets
                                                addiu r6,r5,0x0007	                     #r6 = Counter + 7
@LAFS.not_1st_skill:                            sra r3,r6,0x03		                     #Counter / 8 (byte to load)
                                                addu r2,r4,r3                            #
                                                sll r3,r3,0x03		                     #Counter / 8 * 8
                                                subu r3,r5,r3		                     #r3 = Counter - Counter / 8 * 8
                                                lbu r2,0x0000(r2)	                     #Load Ability Flag s
                                                addiu r3,r3,0x0001	                     #C Mod = (Counter - Counter / 8 *  8) + 1
                                                sllv r2,r2,r3		                     #Ability Flags * 2^(C Mod)
                                                addu r3,r4,r5		                     #r3 = Ability ID Pointer
                                                lbu r3,0x0003(r3)	                     #Load Ability ID
                                                j @LAFS.end_prep                         #
                                                andi r2,r2,0x0100		                 #r2 = Ability ID +0x100 flag
@LAFS.is_a_monster:                             slti r2,r4,0x00e0                        #
                                                beq r2,r0, @LAFS.return_fail_end         #Branch if not a monster skillset
                                                slti r2,r5,0x0004                        #
                                                beq r2,r0, @LAFS.return_fail_end         #Branch if Counter >= 4
                                                addu r6,r5,r0		                     #r6 = Counter
                                                lui r3,0x8006                            #
                                                addiu r3,r3,0x5854		                 #(start back some instead of subtracting)
                                                sll r2,r4,0x02		                     #Skillset * 4
                                                addu r2,r2,r4		                     #Skillset * 5
                                                bgez r5, @LAFS.2nd_not_1st_skill         #Branch if Counter >= 0
                                                addu r4,r2,r3                            #
                                                addiu r6,r5,0x0007                       #
@LAFS.2nd_not_1st_skill:                        sra r3,r6,0x03		                     #Counter / 8
                                                addu r2,r4,r3		                     #
                                                sll r3,r3,0x03		                     #Counter / 8 * 8
                                                subu r3,r5,r3		                     #Counter - Counter / 8 * 8
                                                lbu r2,0x0000(r2)	                     #Load Ability Flags
                                                addiu r3,r3,0x0001	                     #C Mod = (Counter - Counter / 8 * 8) + 1
                                                sllv r2,r2,r3		                     #Ability Flags * 2^(C Mod)
                                                addu r3,r4,r5                            #
                                                lbu r3,0x0001(r3)	                     #Load Ability ID
                                                andi r2,r2,0x0100	                     #r2 = Ability ID's 0x100 Flag
@LAFS.end_prep:                                 j @LAFS.end                              #
                                                or r2,r3,r2			                     #r2 = Full Ability ID (Base ID +  0x100 flag)
@LAFS.return_fail_end:                          addu r2,r0,r0		                     #r2 = 0 (Attack)
@LAFS.end:                                      jr r31                                   #
                                                nop                                      #                     #
																	                     #
#/code

										@Store_Skillset_Abilities: #SSA # 0x0005a638 #code
                                                addiu r29,r29,0xffd8                     #
                                                sw r20,0x0020(r29)                       #
                                                addu r20,r4,r0		                     #r20 = Unit's Skillset
                                                sw r18,0x0018(r29)                       #
                                                addu r18,r5,r0		                     #r18 = Check
                                                slti r2,r20,0x0100                       #
                                                sw r31,0x0024(r29)                       #
                                                sw r19,0x001c(r29)                       #
                                                sw r17,0x0014(r29)                       #
                                                bne r2,r0, @SSA.valid_skillset		     #Branch if Skillset is valid
                                                sw r16,0x0010(r29)                       #
                                                addu r20,r0,r0		                     #Skillset = 0
@SSA.valid_skillset:                            addu r16,r0,r0		                     #Counter = 0 (useless)
                                                addu r17,r0,r0		                     #Counter2 = 0
                                                lui r19,0x8006                           #
                                                addiu r19,r19,0x6204                     #r19 = Pointer to Temp Ability List
@SSA.loop:                                      addu r4,r20,r0		                     #r4 = Skillset
                                                jal @Load_Ability_From_Skillset		     #Load Ability From Skillset
                                                addu r5,r17,r0		                     #r5 = Counter2
                                                addu r4,r2,r0		                     #r4 = Ability ID
                                                andi r3,r4,0xffff	                     #r3 = Ability ID
                                                sltiu r2,r3,0x01a6	                     #(pretty useless series of checks)
                                                bne r2,r0, @SSA.ability_type_prep		 #Branch if Ability is an Ability
                                                andi r2,r18,0x0001		                 #Check = Ability
                                                sltiu r2,r3,0x01c6                       #
                                                bne r2,r0,  @SSA.ability_type_prep		 #Branch if Ability is a Reaction
                                                andi r2,r18,0x0002		                 #Check = Reaction
                                                sltiu r2,r3,0x01e7		                 #(should be 0x1e6, but doesn't matter anyway)
                                                bne r2,r0, @SSA.ability_type_prep		 #Branch if Ability is a Support
                                                andi r2,r18,0x0008		                 #Check = Support
                                                andi r2,r18,0x0004		                 #Check = Movement
@SSA.ability_type_prep:                         bne r2,r0, @SSA.Store_Ability_ID		 #Branch if Check != 0 (Can't get here with r2 = 0)
                                                addiu r16,r16,0x0001		             #Counter ++ (Counter and Counter2 are always the same)
                                                addu r4,r0,r0		                     #Ability ID = 0
@SSA.Store_Ability_ID:                          sh r4,0x0000(r19)		                 #Store Ability ID
                                                addiu r17,r17,0x0001	                 #Counter2 ++
                                                slti r2,r17,0x0018		                 #(Load Ability function stops at 0x16 :/)
                                                bne r2,r0, @SSA.loop                     #Branch if Counter2 < 0x18
                                                addiu r19,r19,0x0002                     #Temp Ability List Pointer += 2
                                                slti r2,r16,0x0018                       #
                                                beq r2,r0, @SSA.end		                 #Branch if Counter >= 0x18 (guaranteed)
                                                sll r2,r16,0x01                          #Counter * 2
                                                lui r3,0x8006                            #
                                                addiu r3,r3,0x6204		                 #(think this was just to null the last
                                                addu r3,r2,r3		                     #abilities, but isn't needed anyway)
@SSA.store_ability_loop:                        sh r0,0x0000(r3)		                 #Store Ability ID = 0
                                                addiu r16,r16,0x0001                     #Counter * 2
                                                slti r2,r16,0x0018                       #
                                                bne r2,r0, @SSA.store_ability_loop		 #Branch if Counter < 0x18
                                                addiu r3,r3,0x0002		                 #Temp Ability List Pointer += 2
@SSA.end:                                       lui r2,0x8006                            #
                                                addiu r2,r2,0x6204		                 #r2 = Temp Ability List Pointer
                                                lw r31,0x0024(r29)                       #
                                                lw r20,0x0020(r29)                       #
                                                lw r19,0x001c(r29)                       #
                                                lw r18,0x0018(r29)                       #
                                                lw r17,0x0014(r29)                       #
                                                lw r16,0x0010(r29)                       #
                                                addiu r29,r29,0x0028                     #
                                                jr r31                                   #
                                                nop                                      #
#/code

										@Calculate_Ability_Pointers_and_Type:  #CAPT # 0x0005a72c #code
                                                andi r4,r4,0x01ff		                 #r4 = Ability ID
                                                sll r3,r4,0x03		                     #ID * 8
                                                lui r2,0x8006                            #
                                                addiu r2,r2,0xebf0                       #
                                                addu r2,r3,r2                            #
                                                sw r2,0x0000(r5)		                 #Store Ability's Data 1 Pointer  (usually on the stack)
                                                slti r2,r4,0x0170                        #
                                                beq r2,r0, @CAPT.not_a_skill		     #Branch if Ability isn't a normal  Ability
                                                subu r2,r3,r4		                     #ID * 7
                                                sll r2,r2,0x01		                     #ID * 14
                                                lui r3,0x8006                            #
                                                addiu r3,r3,0xfbf0                       #
                                                addu r2,r2,r3                            #
                                                sw r2,0x0000(r6)		                 #Store Ability's Data 2 Pointer
                                                j @CAPT.end                              #
                                                addu r2,r0,r0		                     #r2 = 0
@CAPT.not_a_skill:                              slti r2,r4,0x017e                        #
                                                beq r2,r0, @CAPT.not_item		         #Branch if Ability isn't an Item
                                                nop                                      #
                                                lui r2,0x8006                            #
                                                addiu r2,r2,0x0ea0                       #
                                                addu r2,r4,r2                            #
                                                sw r2,0x0000(r6)		                 #Store Item's Ability Pointer
                                                j @CAPT.end                              #
                                                ori r2,r0,0x0001		                 #r2 = 1
@CAPT.not_item:                                 slti r2,r4,0x018a                        #
                                                beq r2,r0, @CAPT.not_throw		         #Branch if Ability isn't a Throw
                                                nop                                      #
                                                lui r2,0x8006                            #
                                                addiu r2,r2,0x0ea2                       #
                                                addu r2,r4,r2                            #
                                                sw r2,0x0000(r6)		                 #Store Throw's Ability Pointer
                                                j @CAPT.end                              #
                                                ori r2,r0,0x0002		                 #r2 = 2
@CAPT.not_throw:                                slti r2,r4,0x0196                        #
                                                beq r2,r0, @CAPT.not_jump		         #Branch if Ability isn't a Jump
                                                sll r2,r4,0x01		                     #ID * 2
                                                lui r3,0x8006                            #
                                                addiu r3,r3,0x0d18                       #
                                                addu r2,r2,r3                            #
                                                sw r2,0x0000(r6)		                 #Store Jump's Ability Pointer
                                                j @CAPT.end                              #
                                                ori r2,r0,0x0003		                 #r2 = 3
@CAPT.not_jump:                                 slti r2,r4,0x019e                        #
                                                beq r2,r0, @CAPT.not_charge		         #Branch if Ability isn't a Charge
                                                sll r2,r4,0x01		                     #ID * 2
                                                lui r3,0x8006                            #
                                                addiu r3,r3,0x0d18                       #
                                                addu r2,r2,r3                            #
                                                sw r2,0x0000(r6)		                 #Store Charge's Ability Pointer
                                                j @CAPT.end                              #
                                                ori r2,r0,0x0004		                 #r2 = 4
@CAPT.not_charge:                               slti r2,r4,0x01a6                        #
                                                beq r2,r0, @CAPT.not_math		         #Branch if Ability isn't Math
                                                nop                                      #
                                                lui r2,0x8006                            #
                                                addiu r2,r2,0x0eb6                       #
                                                addu r2,r4,r2                            #
                                                sw r2,0x0000(r6)		                 #Store Math's Ability Pointer
                                                j @CAPT.end                              #
                                                ori r2,r0,0x0005		                 #r2 = 5
@CAPT.not_math:                                 slti r2,r4,0x01c6                        #
                                                beq r2,r0, @CAPT.not_a_reaction		     #Branch if Ability isn't a Reaction
                                                nop                                      #
                                                lui r2,0x8006                            #
                                                addiu r2,r2,0x0eb6                       #
                                                addu r2,r4,r2                            #
                                                sw r2,0x0000(r6)		                 #Store Reaction's Ability Pointer
                                                j @CAPT.end                              #
                                                ori r2,r0,0x0006		                 #r2 = 6
@CAPT.not_a_reaction:                           slti r2,r4,0x01e6                        #
                                                bne r2,r0, @CAPT.not_a_support		     #Branch if Ability is a Support
                                                nop                                      #
                                                lui r2,0x8006                            #
                                                addiu r2,r2,0x0eb6                       #
                                                addu r2,r4,r2                            #
                                                sw r2,0x0000(r6)		                 #Store Movement's Ability Pointer
                                                j @CAPT.end                              #
                                                ori r2,r0,0x0008		                 #r2 = 8
@CAPT.not_a_support:                            lui r2,0x8006                            #
                                                addiu r2,r2,0x0eb6                       #
                                                addu r2,r4,r2                            #
                                                sw r2,0x0000(r6)		                 #Store Support's Ability Pointer
                                                ori r2,r0,0x0007		                 #r2 = 7
@CAPT.end:                                      jr r31                                   #
                                                nop                                      #
#/code

										@Get_Item_Data_Pointer:  #GIDP # 0x0005a884 #code
                                                andi r4,r4,0x00ff	                      #r4 = Item ID
                                                sll r2,r4,0x01		                      #ID * 2
                                                addu r2,r2,r4		                      #ID * 3
                                                sll r2,r2,0x02		                      #ID * 12
                                                lui r3,0x8006                             #
                                                addiu r3,r3,0x2eb8                        #
                                                jr r31                                    #
                                                addu r2,r2,r3		                      #r2 = Item Data Pointer
#/code

										@Get_Job_Data_Pointer:  #GJDP # 0x0005a8a4 #code
                                                slti r2,r4,0x00a0                         #
                                                bne r2,r0, @GJDP.skip		              #Branch if Job ID < 0xa0 (Legal ID)
                                                sll r2,r4,0x01		                      #ID * 2
                                                j @GJDP.end                               #
                                                addu r2,r0,r0		                      #r2 = 0
@GJDP.skip:                                     addu r2,r2,r4		                      #ID * 3
                                                sll r2,r2,0x04		                      #ID * 48
                                                lui r3,0x8006                             #
                                                addiu r3,r3,0x10b8                        #
                                                addu r2,r2,r3		                      #r2 = Job's Data Pointer
@GJDP.end:                                      jr r31                                    #
                                                nop                                       #
#/code

										@Initialize_Unit_Job_Data:  #IUJD # 0x0005a8d4 #code
                                                addiu r29,r29,0xffd8                      #
                                                sw r18,0x0018(r29)                        #
                                                addu r18,r4,r0		                      #r18 = Unit's Data Pointer
                                                sw r19,0x001c(r29)                        #
                                                addu r19,r5,r0		                      #r19 = Unit's Party ID
                                                sw r31,0x0020(r29)                        #
                                                sw r17,0x0014(r29)                        #
                                                sw r16,0x0010(r29)                        #
                                                lui r1,0x8006                             #
                                                sw r6,0x6200(r1)		                  #Store ?
                                                jal @Get_Party_Data_Pointer	              #Get Party Data Pointer
                                                addu r4,r19,r0		                      #r4 = Unit's Party ID
                                                addu r17,r2,r0		                      #r17 = Unit's Party Data Pointer
                                                beq r17,r0, @IUJD.end_fail	              #Branch if Pointer doesn't exist
                                                ori r2,r0,0x00ff		                  #r2 = FF
                                                lbu r3,0x0001(r17)		                  #Load Unit's Party ID
                                                nop                                       #
                                                beq r3,r2, @IUJD.end_fail		          #Branch if Unit doesn't exist
                                                addiu r4,r17,0x0096	                      #	r4 = Pointer to Unit's Total Base Job JP
                                                addiu r16,r17,0x0064                      #r16 = Pointer to Unit's Base/Chemist Job Level
                                                jal 0x0005df38		                      #Initialize Unit's Job Levels
                                                addu r5,r16,r0		                      #r5 = Pointer to Unit's Base/Chemist Job Level
                                                lbu r5,0x0004(r17)	                      #	Load Unit's Gender Byte
                                                jal @Calculate_Unlocked_Jobs              #Calculate Unlocked Jobs
                                                addu r4,r16,r0		                      #r4 = Pointer to Unit's Base/Chemist Job Level
                                                addiu r4,r17,0x0028	                      #	r4 = Pointer to Unit's Unlocked Jobs
                                                jal 0x0005ded8		                      #Store 3-Byte Data
                                                addu r5,r2,r0		                      #r5 = Unlocked Jobs
                                                jal 0x0005dfac		                      #Initialize Some Unit Data
                                                addu r4,r18,r0		                      #r4 = Unit's Data Pointer
                                                addu r4,r18,r0		                      #r4 = Unit's Data Pointer
                                                addu r5,r17,r0		                      #r5 = Unit's Party Data Pointer
                                                jal @Initialize_Unit_Battle_Data          #Initialize Unit's Battle Data
                                                sb r19,0x0002(r18)	                      #	Store Unit's Party ID
                                                jal @Job_Data_To_Unit_Data                #Transfer Job's Data to Unit's Data
                                                addu r4,r18,r0		                      #r4 = Unit's Data Pointer
                                                jal @Enable_R/S/M_Flags                   #Enable Unit's R/S/M Flags
                                                addu r4,r18,r0		                      #r4 = Unit's Data Pointer
                                                addu r4,r18,r0		                      #r4 = Unit's Data Pointer
                                                jal @Calculate_Actual_Stats               #Calculate Actual Stats
                                                addu r5,r0,r0		                      #r5 = 0 (Level UP)
                                                jal @Equippable_Item_Setting              #Equippable Item Setting (Support/Female-only)
                                                addu r4,r18,r0		                      #r4 = Unit's Data Pointer
                                                jal @Generate_Unit_Bonus_Stats		      #Equipment/Move/Jump +X/Name Storing/Generation
                                                addu r4,r18,r0		                      #r4 = Unit's Data Pointer
                                                j @IUJD.end                               #
                                                addu r2,r0,r0		                      #r2 = 0 (success)
@IUJD.end_fail:                                 addiu r2,r0,0xffff	                      #	r2 = FFFF (fail)
@IUJD.end:                                      lw r31,0x0020(r29)                        #
                                                lw r19,0x001c(r29)                        #
                                                lw r18,0x0018(r29)                        #
                                                lw r17,0x0014(r29)                        #
                                                lw r16,0x0010(r29)                        #
                                                addiu r29,r29,0x0028                      #
                                                jr r31                                    #
                                                nop                                       #
#/code

										@Unit_Battle_Initialization:  #UBI # 0x0005a9b4 #code
                                                addiu r29,r29,0xffe0                      #
                                                sw r16,0x0010(r29)                        #
                                                addu r16,r4,r0		                      #r16 = Unit's Data Pointer
                                                sw r17,0x0014(r29)                        #
                                                sw r18,0x0018(r29)                        #
                                                addu r18,r7,r0		                      #r18 = r7
                                                ori r2,r0,0x0082	                      #	r2 = 0x82
                                                sw r31,0x001c(r29)                        #
                                                lui r1,0x8006                             #
                                                sw r6,0x6200(r1)	                      #Store Battle Initialization Flag? (1 in 0x59b18)
                                                beq r18,r2, @UBI.monster_gender?          #Branch if r18 = 0x82 (monster gender?)
                                                addu r17,r5,r0		                      #r17 = ENTD Data Pointer
                                                jal 0x0005dfac		                      #Initialize Some Unit Data
                                                nop                                       #
                                                addu r4,r16,r0		                      #r4 = Unit's Data Pointer
                                                jal @ENTD_Data_Calculation                #ENTD Data Calculation
                                                addu r5,r17,r0		                      #r5 = ENTD Data Pointer
                                                bne r2,r0, @UBI.end                       #Branch if ENTD Data Calculation failed
                                                addiu r2,r0,0xffff	                      #	r2 = FFFF
@UBI.monster_gender?:                           bne r18,r0, @UBI.calculate_jobs	          #Branch if r18 = 0
                                                addu r4,r16,r0		                      #r4 = Unit's Data Pointer
                                                lbu r2,0x0001(r17)		                  #Load ENTD's Gender Byte
                                                nop                                       #
                                                andi r2,r2,0x0008                         #
                                                bne r2,r0, @UBI.end	                      #Branch if Unit has Load Formation
                                                addu r2,r0,r0		                      #r2 = 0
                                                lbu r2,0x0000(r17)		                  #Load ENTD Sprite Set
                                                nop                                       #
                                                sltiu r2,r2,0x0004                        #
                                                beq r2,r0, @UBI.calculate_jobs            #Branch if Unit isn't Ramza
                                                nop                                       #
                                                lbu r2,0x0004(r17)		                  #Load ENTD Birth Month
                                                nop                                       #
                                                beq r2,r0, @UBI.end	                      #Branch if Birth Month = 0
                                                addu r2,r0,r0		                      #r2 = 0
@UBI.calculate_jobs:                            jal @Calculate_ENTD_Unit_Jobs             #Calculate ENTD Unit Jobs
                                                addu r5,r17,r0		                      #r5 = ENTD Data Pointer
                                                addu r4,r16,r0		                      #r4 = Unit's Data Pointer
                                                jal @Calculate_Unit_Abilities             #Calculate Unit's Abilities
                                                addu r5,r17,r0		                      #r5 = ENTD Data Pointer
                                                jal @Enable_R/S/M_Flags                   #Enable Unit's R/S/M Flags
                                                addu r4,r16,r0		                      #r4 = Unit's Data Pointer
                                                jal @Generate_Base_Raw_Stats_Prep_BATTLE  #Prep for Generating Base Raw Stats
                                                addu r4,r16,r0		                      #r4 = Unit's Data Pointer
                                                jal @Transfer_Job_Stats_to_Unit		      #Transfer Job's Growths/Mults to Unit
                                                addu r4,r16,r0		                      #r4 = Unit's Data Pointer
                                                lbu r3,0x0002(r16)		                  #Load Unit's Party ID
                                                ori r2,r0,0x00ff		                  #r2 = FF
                                                bne r3,r2, @UBI.party_unit		          #Branch if Unit is in the party
                                                addu r4,r16,r0		                      #r4 = Unit's Data Pointer
                                                ori r2,r0,0x00fe		                  #r2 = FE
                                                sb r2,0x0002(r16)		                  #Store Unit's Party ID = FE (just for leveling up)
@UBI.party_unit:                                jal @Calculate_Actual_Stats               #Calculate Actual Stats
                                                addu r5,r0,r0		                      #r5 = 0 (Level UP)
                                                lbu r3,0x0002(r16)		                  #Load Unit's Party ID
                                                ori r2,r0,0x00fe		                  #r2 = FE
                                                bne r3,r2, @UBI.2nd_party_unit            #Branch if Unit is in the party
                                                ori r2,r0,0x00ff		                  #r2 = FF
                                                sb r2,0x0002(r16)		                  #Store Unit's Party ID = FF
@UBI.2nd_party_unit:                            jal @Equippable_Item_Setting              #Equippable Item Setting (Support/Female-only)
                                                addu r4,r16,r0		                      #r4 = Unit's Data Pointer
                                                ori r2,r0,0x0082		                  #r2 = 0x82
                                                beq r18,r2, @UBI.skip	                  #Branch if r18 = 0x82
                                                nop                                       #
                                                lbu r2,0x0002(r16)		                  #Load Unit's Party ID
                                                nop                                       #
                                                sltiu r2,r2,0x0014                        #
                                                bne r2,r0, @UBI.skip                      #Branch if Unit is in the party/ID is legal
                                                addu r4,r16,r0		                      #r4 = Unit's Data Pointer
                                                jal @Calculate_ENTD_Unit_Equipment        #Calculate/Store ENTD Unit Equipment
                                                addu r5,r17,r0		                      #r5 = ENTD Pointer
@UBI.skip:                                      jal @Generate_Unit_Bonus_Stats		      #Equipment/Move/Jump +X/Name Storing/Generation
                                                addu r4,r16,r0		                      #r4 = Unit's Data Pointer
                                                jal @Store_Ramza_Birthday_Zodiac          #Store Ramza's Name/Birthday/Zodiac
                                                addu r4,r16,r0		                      #r4 = Unit's Data Pointer
                                                addu r2,r0,r0		                      #r2 = 0 (Success)
@UBI.end:                                       lw r31,0x001c(r29)                        #
                                                lw r18,0x0018(r29)                        #
                                                lw r17,0x0014(r29)                        #
                                                lw r16,0x0010(r29)                        #
                                                addiu r29,r29,0x0020                      #
                                                jr r31                                    #
                                                nop                                       #
																	                      #
#/code

										@Generate_Unit_Bonus_Stats:  #GUBS # 0x0005ab00 #code
                                                addiu r29,r29,0xffe8                      #
                                                sw r16,0x0010(r29)                        #
                                                sw r31,0x0014(r29)                        #
                                                jal @Equipment_Stat_Setting               #Equipment Stat Setting
                                                addu r16,r4,r0		                      #r16 = Unit's Data Pointer
                                                addu r4,r16,r0		                      #r4 = Unit's Data Pointer
                                                jal @Equipment_Attribute_Setting          #Equipment Attribute Setting
                                                ori r5,r0,0x0001	                      #r5 = 1 (Level UP calculation)
                                                addu r4,r16,r0		                      #r4 = Unit's Data Pointer
                                                jal @Move_Jump_Calculation                #Move/Jump +X Calculation
                                                addu r5,r0,r0		                      #r5 = 0 (Set HP/MP to Max)
                                                jal @Generate_Character_Names             #Store/Generate Character Names
                                                addu r4,r16,r0		                      #r4 = Unit's Data Pointer
                                                lw r31,0x0014(r29)                        #
                                                lw r16,0x0010(r29)                        #
                                                addiu r29,r29,0x0018                      #
                                                jr r31                                    #
                                                nop                                       #
#/code
												
										@Store_Ramza_Birthday_Zodiac:  #SRBZ  #code
0x0005ab48:                                     addiu r29,r29,0xffe0                      #
                                                sw r17,0x0014(r29)                        #
                                                addu r17,r4,r0		                      #r17 = Unit's Data Pointer
                                                sw r31,0x0018(r29)                        #
                                                sw r16,0x0010(r29)                        #
                                                lbu r2,0x0000(r17)		                  #Load Unit's Sprite Set
                                                nop                                       #
                                                sltiu r2,r2,0x0004                        #
                                                beq r2,r0, @SRBZ.end                      #Branch if Unit isn't Ramza
                                                addu r16,r0,r0		                      #Counter = 0
@SRBZ.loop:                                     jal @Get_Party_Data_Pointer		          #Get Party Data Pointer		
                                                addu r4,r16,r0		                      #Party ID = Counter
                                                addu r4,r2,r0		                      #r4 = Party Data Pointer
                                                lbu r3,0x0001(r4)	                      #	Load Unit's Party ID
                                                ori r2,r0,0x00ff                          #
                                                beq r3,r2, @SRBZ.check_next_unit          #Branch if Unit doesn't exist
                                                nop                                       #
                                                lbu r2,0x0000(r4)	                      #Load Unit's Party Sprite Set
                                                nop                                       #
                                                sltiu r2,r2,0x0004                        #
                                                beq r2,r0, @SRBZ.not_ramza                #Branch if Unit isn't Ramza
                                                addiu r16,r16,0x0001                      #Counter ++
                                                addiu r5,r17,0x012c	                      #r5 = Unit's Name
                                                ori r6,r0,0x0010	                      #Limit = 16
                                                lbu r2,0x0006(r4)	                      #Load Unit's Party Zodiac Sign
                                                lbu r3,0x0005(r4)	                      #Load Unit's Party Birthday
                                                sll r2,r2,0x08		                      #Zodiac * 256
                                                addu r3,r3,r2		                      #Full Birthday = Birthday + Zodiac * 256
                                                lhu r2,0x0008(r17)	                      #Load Unit's Birthday + Zodiac
                                                andi r3,r3,0x01ff	                      #r3 = Party Birthday
                                                andi r2,r2,0xfe00	                      #r2 = Unit's Zodiac
                                                or r2,r2,r3			                      #Enable Unit's Party Birthday
                                                sh r2,0x0008(r17)	                      #	Store Unit's New Birthday
                                                lbu r3,0x0006(r4)	                      #Load Unit's Party Zodiac Sign
                                                addiu r4,r4,0x00be	                      #r4 = Unit's Party Name
                                                andi r2,r2,0x0fff	                      #r2 = Unit's Birthday
                                                srl r3,r3,0x04		                      #Party Zodiac / 16
                                                sll r3,r3,0x0c		                      #Full Zodiac = Party Zodiac / 16 * 4096
                                                or r2,r2,r3			                      #Enable Unit's Party Zodiac
                                                jal 0x0005e254		                      #Store X Byte into Y (Unit's Name)
                                                sh r2,0x0008(r17)	                      #Store Unit's New Birthday + Zodiac
                                                j @SRBZ.end                               #
                                                nop                                       #
@SRBZ.check_next_unit:                          addiu r16,r16,0x0001                      #Counter ++
@SRBZ.not_ramza:                                slti r2,r16,0x0014                        #
                                                bne r2,r0, @SRBZ.loop                     #Branch if Counter < 20
                                                nop                                       #
@SRBZ.end:                                      lw r31,0x0018(r29)                        #
                                                lw r17,0x0014(r29)                        #
                                                lw r16,0x0010(r29)                        #
                                                addiu r29,r29,0x0020                      #
                                                jr r31                                    #
                                                nop					                      #
#/code

										@ENTD_Data_Calculation:  #EDC  #code
0x0005ac1c:                                    addiu r29,r29,0xffd0                       #
                                               sw r18,0x0018(r29)                         #
                                               addu r18,r5,r0		                      #r18 = ENTD Pointer
                                               sw r31,0x0028(r29)                         #
                                               sw r21,0x0024(r29)                         #
                                               sw r20,0x0020(r29)                         #
                                               sw r19,0x001c(r29)                         #
                                               sw r17,0x0014(r29)                         #
                                               sw r16,0x0010(r29)                         #
                                               lbu r2,0x0017(r18)		                  #Load ENTD Palette
                                               addu r19,r4,r0		                      #r19 = Unit's Data Pointer
                                               sb r2,0x0004(r19)		                  #Store Unit's Palette
                                               lbu r2,0x0018(r18)		                  #Load ENTD Flags
                                               nop                                        #
                                               sb r2,0x0005(r19)		                  #Store Unit's ENTD Flags
                                               lbu r2,0x0018(r18)		                  #Load ENTD Flags
                                               nop                                        #
                                               sb r2,0x01ba(r19)		                  #Store Unit's Modified ENTD Flags
                                               lbu r16,0x0001(r18)		                  #Load ENTD Gender Byte
                                               nop                                        #
                                               andi r2,r16,0x0008                         #
                                               beq r2,r0, @EDC.no_load_formation          #Branch if Unit doesn't have Load Formation
                                               nop                                        #
                                               jal @Prep_for_Initializing_Unit_Job_Data   #Prep for Initializing Unit's Job Data
                                               nop                                        #
                                               j @EDC.guest_load                          #
                                               addu r20,r2,r0		                      #r2 = Success Check
@EDC.no_load_formation:                        lbu r2,0x0000(r18)		                  #Load Unit's ENTD Sprite Set
                                               nop                                        #
                                               sltiu r2,r2,0x0004                         #
                                               beq r2,r0, @EDC.loop_start                 #Branch if Unit isn't Ramza
                                               addu r4,r0,r0		                      #r4 = 0
                                               lbu r2,0x0004(r18)		                  #Load Unit's ENTD Birth Month
                                               nop                                        #
                                               bne r2,r0, @EDC.loop_start                 #Branch if Month != 0 (Ramza Initialization)
                                               nop                                        #
                                               addu r17,r0,r0		                      #Counter = 0
                                               lui r21,0x8006                             #
                                               addiu r21,r21,0x10e8		                  #r21 = Ramza's Job Data Pointer
@EDC.unit_load_loop_start:                     jal @Get_Party_Data_Pointer                #Get Party Data Pointer
                                               addu r4,r17,r0		                      #r4 = Counter
                                               addu r4,r2,r0		                      #r4 = Party Data Pointer
                                               lbu r3,0x0001(r4)                          #Load Unit's Party ID
                                               ori r2,r0,0x00ff		                      #r2 = FF
                                               beq r3,r2, @EDC.check_next_unit            #Branch if Unit's Party ID = FF
                                               nop                                        #
                                               lbu r2,0x0000(r4)		                  #Load Unit's Sprite Set
                                               nop                                        #
                                               sltiu r2,r2,0x0004                         #
                                               beq r2,r0, @EDC.check_next_unit            #Branch if Unit isn't Ramza
                                               nop                                        #
                                               lbu r2,0x0002(r4)		                  #Load Unit's Job ID
                                               lbu r3,0x0000(r18)		                  #Load Unit's ENTD Sprite Set
                                               sltiu r2,r2,0x0003                         #
                                               sb r3,0x0000(r4)                           #Store Unit's Sprite Set
                                               lbu r3,0x0007(r4)		                  #Load Unit's Secondary Skillset
                                               beq r2,r0, @EDC.not_ramza_job              #Branch if Unit's Job isn't Ramza's Squire
                                               andi r3,r3,0x00ff                          #
                                               lbu r2,0x0000(r18)		                  #Load Unit's ENTD Sprite Set
                                               nop                                        #
                                               sb r2,0x0002(r4)                           #Store Unit's Job ID = Sprite Set
@EDC.not_ramza_job:                            lbu r2,0x0000(r21)		                  #Load Job's Skillset
                                               nop                                        #
                                               beq r3,r2, @EDC.load_sprite_set            #Branch if Job's Skillset = Unit's Secondary Skillset
                                               nop                                        #
                                               lbu r2,0x0030(r21)		                  #Load 2nd Job's Skillset
                                               nop                                        #
                                               beq r3,r2, @EDC.load_sprite_set            #Branch if 2nd Job's Skillset = Unit's Secondary Skillset
                                               nop                                        #
                                               lbu r2,0x0060(r21)		                  #Load 3rd Job's Skillset
                                               nop                                        #
                                               bne r3,r2, @EDC.skip		                  #Branch if 3rd Job's Skillset != Unit's Secondary Skillset
                                               nop                                        #
@EDC.load_sprite_set:                          lbu r2,0x0000(r18)		                  #Load Unit's ENTD Sprite Set
                                               nop                                        #
                                               sll r3,r2,0x01		                      #ID * 2
                                               addu r3,r3,r2		                      #ID * 3
                                               sll r3,r3,0x04		                      #ID * 48
                                               lui r1,0x8006                              #
                                               addu r1,r1,r3                              #
                                               lbu r2,0x10b8(r1)	                      #Load Sprite Set's Job's Skillset
                                               nop                                        #
                                               sb r2,0x0007(r4)		                      #Store Unit's Secondary Skillset = Sprite Set's Job's Skillset
@EDC.skip:                                     addu r4,r19,r0		                      #r4 = Units Data Pointer
                                               jal @Prep_for_Initializing_Unit_Job_Data   #Prep for Initializing Unit's Job Data
                                               addu r5,r18,r0		                      #r5 = ENTD Pointer
                                               addu r20,r2,r0		                      #r20 = Success Check
                                               ori r16,r0,0x0008	                      #Gender Byte = 8 (Load Formation Flag)
@EDC.check_next_unit:                          addiu r17,r17,0x0001	                      #Counter ++
                                               slti r2,r17,0x0014                         #
                                               bne r2,r0, @EDC.unit_load_loop_start       #Branch if Counter < 20
                                               nop                                        #
@EDC.guest_load:                               addu r4,r0,r0		                      #Counter = 0
@EDC.loop_start:                               lui r2,0x8006                              #
                                               lw r2,0x6238(r2)		                      #Load Current ENTD Pointer
                                               addu r3,r19,r4		                      #r3 = Unit's Data Pointer + Counter
                                               addu r2,r2,r4		                      #r2 = Current ENTD Pointer + Counter
                                               lbu r2,0x0021(r2)	                      #Load ENTD AI Data
                                               addiu r4,r4,0x0001	                      #Counter ++
                                               sb r2,0x0165(r3)		                      #Store Unit's ENTD AI Data
                                               slti r2,r4,0x0007                          #
                                               bne r2,r0, @EDC.loop_start                 #Branch if Counter < 7
                                               andi r2,r16,0x0008		                  #r2 = Unit's Load Formation Flag
                                               bne r2,r0, @EDC.load_formation_end         #Branch if Unit has Load Formation
                                               addu r2,r20,r0		                      #r2 = Success Check
                                               sb r16,0x0006(r19)		                  #Store Unit's Gender Byte
                                               lbu r3,0x0000(r18)		                  #Load ENTD Sprite Set
                                               ori r2,r0,0x00ff		                      #r2 = FF
                                               sb r2,0x0002(r19)		                  #Store Unit's Party ID = FF
                                               sb r3,0x0000(r19)		                  #Store Unit's Sprite Set = ENTD Sprite Set
                                               lbu r16,0x0003(r18)		                  #Load ENTD Level
                                               nop                                        #
                                               andi r3,r16,0x00ff                         #
                                               beq r3,r0, @EDC.lvl_equal_party_lvl        #Branch if Level = Party Level
                                               ori r2,r0,0x00fe		                      #r2 = FE
                                               bne r3,r2, @EDC.lvl_equal_random           #Branch if Level != Party Level: Random
                                               sltiu r2,r3,0x0064                         #
@EDC.lvl_equal_party_lvl:                      lui r3,0x8006                              #
                                               lbu r3,0x6308(r3)		                  #Load Highest Party Level
                                               nop                                        #
                                               srl r2,r3,0x03		                      #High Level / 8
                                               addiu r16,r2,0x0001		                  #ENTD Level = High Level / 8 + 1
                                               jal @Random_Number                         #Random Number Generator
                                               subu r17,r3,r2		                      #r17 = High Level - High Level / 8
                                               mult r16,r2			                      #(High Level / 8 + 1) * Random
                                               mflo r2                                    #
                                               bgez r2, @EDC.positive_number              #Branch if Result is Positive
                                               nop                                        #
                                               addiu r2,r2,0x7fff                         #
@EDC.positive_number:                          sra r2,r2,0x0f		                      #Result = rand(0..High Level / 8)
                                               j @EDC.random_lvl_skip                     #
                                               addu r16,r17,r2		                      #r16 = rand((High Level - High Level / 8)..High Level)
@EDC.lvl_equal_random:                         bne r2,r0, @EDC.lvl_less_than_100          #Branch if Level < 100
                                               addu r3,r16,r0		                      #r3 = ENTD Level
                                               lui r2,0x8006                              #
                                               lbu r2,0x6308(r2)		                  #Load Highest Party Level
                                               nop                                        #
                                               addiu r2,r2,0x009c		                  #High Level += 0x9c
                                               addu r16,r16,r2                            #Level = Level + High Level + 0x9c
@EDC.random_lvl_skip:                          addu r3,r16,r0                             #r3 = " (amount over 0x100 = Level to obtain)
@EDC.lvl_less_than_100:                        andi r2,r3,0x00ff                          #
                                               bne r2,r0, @EDC.lvl_not_0                  #Branch if Level != 0
                                               addu r16,r3,r0                             #
                                               ori r3,r0,0x0001                           #
                                               addu r16,r3,r0		                      #Level = 1
@EDC.lvl_not_0:                                andi r2,r16,0x00ff                         #
                                               sltiu r2,r2,0x0064                         #
                                               bne r2,r0, @EDC.2nd_lvl_less_than_100      #Branch if Level < 100
                                               nop                                        #
                                               ori r16,r0,0x0063		                  #Level = 99
@EDC.2nd_lvl_less_than_100:                    sb r16,0x0022(r19)		                  #Store Unit's Level
                                               lbu r3,0x0004(r18)		                  #Load ENTD Birth Month
                                               lbu r16,0x0005(r18)		                  #Load ENTD Birth Day
                                               beq r3,r0, @EDC.generate_random_value      #Branch if Birth Month = 0
                                               sltiu r2,r3,0x000d                         #
                                               beq r2,r0, @EDC.generate_random_value      #Branch if Month isn't legal
                                               andi r2,r16,0x00ff                         #
                                               beq r2,r0, @EDC.generate_random_value      #Branch if Day is 0
                                               sltiu r2,r2,0x0020                         #
                                               bne r2,r0, @EDC.legal_day                  #Branch if Day is legal
                                               sll r2,r3,0x01                             #Month * 2
@EDC.generate_random_value:                    jal @Random_Number		                  #Random Number Generator
                                               nop                                        #
                                               sll r3,r2,0x03		                      #Random * 8
                                               addu r3,r3,r2		                      #Random * 9
                                               sll r3,r3,0x03		                      #Random * 72
                                               addu r3,r3,r2		                      #Random * 73
                                               sll r2,r3,0x02		                      #Random * 292
                                               addu r2,r3,r2		                      #Random * 365
                                               bgez r2, @EDC.2nd_positive_number          #Branch if Random * 365 is positive (it is)
                                               nop                                        #
                                               addiu r2,r2,0x7fff                         #
@EDC.2nd_positive_number:                      sra r2,r2,0x0f                             #Birthday = rand(0..364)
                                               j @EDC.store_birthday                      #
                                               addiu r2,r2,0x0001		                  #Birthday += 1
@EDC.legal_day:                                lui r1,0x8006                              #
                                               addu r1,r1,r2                              #
                                               lhu r2,0x61ce(r1)		                  #Load Month's Day Value
                                               nop                                        #
                                               addu r2,r2,r16                             #Birth Day = Day + Month's Day Value
@EDC.store_birthday:                           andi r4,r2,0xffff                          #
                                               lhu r2,0x0008(r19)		                  #Load Unit's Birthday
                                               andi r3,r4,0x01ff		                  #r3 = Unit's Birthday
                                               andi r2,r2,0xfe00		                  #r2 = Unit's Zodiac
                                               or r2,r2,r3                                #Unit's Birthday + Zodiac
                                               jal 0x0005e5d8                             #Calculate Zodiac Symbol
                                               sh r2,0x0008(r19)		                  #Store Unit's new Birthday
                                               andi r2,r2,0xffff		                  #r2 = Zodiac ID
                                               lhu r3,0x0008(r19)		                  #Load Unit's Birthday
                                               sll r2,r2,0x0c                             #ID * 0x1000
                                               andi r3,r3,0x0fff		                  #r3 = Unit's Birthday
                                               or r4,r3,r2                                #Unit's Birthday + Zodiac Sign
                                               sh r4,0x0008(r19)		                  #Store Unit's new Birthday
                                               lbu r3,0x000a(r18)		                  #Load ENTD Job ID
                                               ori r2,r0,0x0097                           #r2 = 0x97
                                               bne r3,r2, @EDC.not_serpentarius           #Branch if Job != Serpentarius
                                               andi r2,r4,0x0fff		                  #r2 = Unit's Birthday + Zodiac
                                               ori r2,r2,0xc000                           #Enable Serpentarius
                                               sh r2,0x0008(r19)		                  #Store Unit's new Birthday
@EDC.not_serpentarius:                         lbu r16,0x0006(r18)		                  #Load ENTD Brave
                                               nop                                        #
                                               sltiu r2,r16,0x0065                        #
                                               bne r2,r0, @EDC.brave_skip                 #Branch if Brave < 101
                                               nop                                        #
                                               jal @Random_Number		                  #Random Number Generator
                                               nop                                        #
                                               sll r3,r2,0x04		                      #Random * 16
                                               subu r3,r3,r2		                      #Random * 15
                                               sll r2,r3,0x01		                      #Random * 30
                                               bgez r2, @EDC.3rd_positive_number          #Branch if Random is positive
                                               nop                                        #
                                               addiu r2,r2,0x7fff                         #
@EDC.3rd_positive_number:                      sra r2,r2,0x0f                             #rand(0..29)
                                               addiu r16,r2,0x002d		                  #Brave = rand(0..29) + 45
@EDC.brave_skip:                               sb r16,0x0024(r19)		                  #Store Unit's Brave
                                               sb r16,0x0023(r19)		                  #Store Unit's Original Brave
                                               lbu r16,0x0007(r18)		                  #Load ENTD Faith
                                               nop                                        #
                                               sltiu r2,r16,0x0065                        #
                                               bne r2,r0, @EDC.faith_skip                 #Branch if Faith < 101
                                               nop                                        #
                                               jal @Random_Number		                  #Random Number Generator
                                               nop                                        #
                                               sll r3,r2,0x04		                      #Random * 16
                                               subu r3,r3,r2		                      #Random * 15
                                               sll r2,r3,0x01		                      #Random * 30
                                               bgez r2, @EDC.4th_positive_number          #Branch if Random is Positive
                                               nop                                        #
                                               addiu r2,r2,0x7fff                         #
@EDC.4th_positive_number:                      sra r2,r2,0x0f		                      #rand(0..29)
                                               addiu r16,r2,0x002d		                  #Faith = rand(0..29) + 45
@EDC.faith_skip:                               sb r16,0x0026(r19)		                  #Store Unit's Faith
                                               sb r16,0x0025(r19)		                  #Store Unit's Original Faith
                                               lbu r16,0x001c(r18)		                  #Load ENTD Starting Experience
                                               nop                                        #
                                               sltiu r2,r16,0x0064                        #
                                               bne r2,r0, @EDC.exp_skip                   #Branch if Starting Experience < 100
                                               nop                                        #
                                               jal @Random_Number		                  #Random Number Generator
                                               nop                                        #
                                               sll r3,r2,0x01		                      #Random * 2
                                               addu r3,r3,r2		                      #Random * 3
                                               sll r3,r3,0x03		                      #Random * 24
                                               addu r3,r3,r2		                      #Random * 25
                                               sll r3,r3,0x02		                      #Random * 100
                                               bgez r3, @EDC.exp_skip                     #Branch if Random is positive
                                               srl r16,r3,0x0f                            #rand(0..99)
                                               addiu r3,r3,0x7fff                         #
                                               srl r16,r3,0x0f                            #
@EDC.exp_skip:                                 sb r16,0x0021(r19)		                  #Store Unit's Experience
                                               lbu r3,0x0002(r18)		                  #Load ENTD Name ID
                                               addu r2,r0,r0		                      #r2 = 0 (Success)
                                               sh r3,0x016c(r19)		                  #Store Unit's Name ID
@EDC.load_formation_end:                       lw r31,0x0028(r29)                         #
                                               lw r21,0x0024(r29)                         #
                                               lw r20,0x0020(r29)                         #
                                               lw r19,0x001c(r29)                         #
                                               lw r18,0x0018(r29)                         #
                                               lw r17,0x0014(r29)                         #
                                               lw r16,0x0010(r29)                         #
                                               addiu r29,r29,0x0030                       #
                                               jr r31                                     #
                                               nop                                        #
#/code											   

										@Prep_for_Initializing_Unit_Job_Data:  #PIUJ  #code										   
0x0005b038:                                    addiu r29,r29,0xffe0                       #
                                               sw r16,0x0010(r29)                         #
                                               addu r16,r4,r0		                      #r16 = Unit's Data Pointer
                                               sw r17,0x0014(r29)                         #
                                               addu r17,r5,r0		                      #r17 = ENTD Data Pointer
                                               sw r31,0x0018(r29)                         #
                                               lbu r4,0x0000(r17)		                  #Load ENTD Sprite Set
                                               jal @Find_Unit_Party_Data_Location		  #Find Unit's Party Data Location
                                               nop                                        #
                                               addu r5,r2,r0		                      #r5 = Party ID
                                               addiu r2,r0,0xffff		                  #r2 = FFFF (Fail)
                                               beq r5,r2, @PIUJ.end		                  #Branch if Unit doesn't exist
                                               nop                                        #
                                               lui r6,0x8006                              #
                                               lw r6,0x6200(r6)		                      #Load Battle Initialization Flag? (Loaded just to store)
                                               jal @Initialize_Unit_Job_Data              #Initialize Unit's Job Data
                                               addu r4,r16,r0		                      #r4 = Unit's Data Pointer
                                               lbu r3,0x0006(r16)		                  #Load Unit's Gender Byte
                                               nop                                        #
                                               andi r3,r3,0x00ee                          #
                                               sb r3,0x0006(r16)		                  #Store Gender Byte without Join After Event/Save Formation
                                               lbu r2,0x0001(r17)		                  #Load Unit's ENTD Gender Byte
                                               nop                                        #
                                               andi r2,r2,0x0011                          #
                                               or r3,r3,r2			                      #Enable Unit's Join After Event/Save Formation Flags
                                               sb r3,0x0006(r16)		                  #Store Unit's new Gender Byte
                                               lbu r2,0x0018(r17)		                  #Load Unit's ENTD Flags
                                               nop                                        #
                                               sb r2,0x0005(r16)		                  #Store Unit's ENTD Flags
                                               lbu r3,0x0018(r17)		                  #Load Unit's ENTD Flags
                                               addu r2,r0,r0                              #r2 = 0 (Success)
                                               sb r3,0x01ba(r16)		                  #Store Unit's Modified ENTD Flags
@PIUJ.end:                                     lw r31,0x0018(r29)                         #
                                               lw r17,0x0014(r29)                         #
                                               lw r16,0x0010(r29)                         #
                                               addiu r29,r29,0x0020                       #
                                               jr r31                                     #
                                               nop                                        #
#/code

										@Initialize_Unit_Battle_Data:  #IUBD  #code
0x0005b0d0:                                    addiu r29,r29,0xffe0		                   #(very badly done)
                                               sw r17,0x0014(r29)                          #
                                               addu r17,r4,r0		                       #r17 = Unit's Data Pointer
                                               sw r16,0x0010(r29)                          #
                                               addu r16,r5,r0		                       #r16 = Unit's Party Data Pointer
                                               sw r31,0x0018(r29)                          #
                                               lbu r2,0x0000(r16)		                   #Load Unit's Sprite Set
                                               nop                                         #
                                               sltiu r2,r2,0x0004                          #
                                               beq r2,r0, @IUBD.not_ramza                  #Branch if Sprite Set isn't Ramza
                                               ori r3,r0,0x0008		                       #ENTD Flags = 0x8 (Control)
                                               ori r3,r0,0x000b		                       #ENTD Flags = 0xb (Control, 0x01 and 0x02)
@IUBD.not_ramza:                               sb r3,0x0005(r17)		                   #Store Unit's ENTD Flags
                                               sb r3,0x01ba(r17)		                   #Store Unit's Modified ENTD Flags
                                               lbu r2,0x0000(r16)		                   #Load Unit's Sprite Set
                                               nop                                         #
                                               sb r2,0x0000(r17)		                   #Store Unit's Sprite Set
                                               lbu r2,0x0001(r16)		                   #Load Unit's Party ID
                                               nop                                         #
                                               sb r2,0x0002(r17)		                   #Store Unit's Party ID
                                               lbu r2,0x0002(r16)		                   #Load Unit's Job ID
                                               nop                                         #
                                               sb r2,0x0003(r17)		                   #Store Unit's Job ID
                                               lbu r2,0x0001(r16)		                   #Load Unit's Party ID
                                               lbu r3,0x0003(r16)		                   #Load Unit's Palette
                                               sltiu r2,r2,0x0010                          #
                                               beq r2,r0, @IUBD.not_party_unit             #Branch if Unit isn't in the Main Party
                                               addiu r4,r16,0x000e		                   #r4 = Unit's Party Equipment Data Pointer
                                               addu r3,r0,r0		                       #r3 = 0 (default Palette)
@IUBD.not_party_unit:                          sb r3,0x0004(r17)		                   #Store Unit's Palette
                                               lbu r2,0x0004(r16)		                   #Load Unit's Gender Byte
                                               addiu r5,r17,0x001a		                   #r5 = Unit's Equipment Data Pointer
                                               sb r2,0x0006(r17)		                   #Store Unit's Gender Byte
                                               lbu r2,0x0006(r16)		                   #Load Unit's Zodiac Sign
                                               lbu r3,0x0005(r16)		                   #Load Unit's Birthday (could load/store as halfword)
                                               sll r2,r2,0x08		                       #Zodiac Sign * 256
                                               addu r3,r3,r2		                       #Zodiac Sign * 256 + Birthday
                                               lhu r2,0x0008(r17)		                   #Load Unit's Birthday + Zodiac Sign
                                               andi r3,r3,0x01ff		                   #r3 = Unit's Birthday
                                               andi r2,r2,0xfe00		                   #r2 = Unit's Zodiac Sign
                                               or r2,r2,r3			                       #r2 = Unit's Birthday + Zodiac Sign
                                               sh r2,0x0008(r17)		                   #Store Unit's Birthday + Zodiac Sign
                                               lbu r3,0x0006(r16)		                   #Load Unit's Zodiac Sign
                                               andi r2,r2,0x0fff		                   #r2 = Unit's Birthday
                                               srl r3,r3,0x04		                       #Zodiac Sign / 16
                                               sll r3,r3,0x0c		                       #Zodiac Sign / 16 * 4096
                                               or r2,r2,r3			                       #r2 = Zodiac Sign / 16 * 4096 + Unit's Birthday
                                               sh r2,0x0008(r17)		                   #Store Unit's Birthday + Zodiac Sign
                                               lbu r2,0x0007(r16)		                   #Load Unit's Secondary Skillset
                                               ori r6,r0,0x0007		                       #Limit = 7
                                               sb r2,0x0013(r17)		                   #Store Unit's Secondary Skillset
                                               lbu r2,0x0009(r16)		                   #Load Unit's Reaction Ability (high bit)
                                               lbu r3,0x0008(r16)		                   #Load Unit's Reaction Ability
                                               sll r2,r2,0x08		                       #High Bit * 256
                                               addu r3,r3,r2		                       #Reaction Ability + High Bit * 256
                                               sh r3,0x0014(r17)		                   #Store Unit's Reaction ID
                                               lbu r2,0x000b(r16)		                   #Load Unit's Support Ability (high Bit)
                                               lbu r3,0x000a(r16)		                   #Load Unit's Support Ability
                                               sll r2,r2,0x08		                       #High Bit * 256
                                               addu r3,r3,r2		                       #Support Ability + High Bit * 256
                                               sh r3,0x0016(r17)		                   #Store Unit's Support Ability ID
                                               lbu r2,0x000d(r16)		                   #Load Unit's Movement Ability (high bit)
                                               lbu r3,0x000c(r16)		                   #Load Unit's Movement Ability
                                               sll r2,r2,0x08		                       #High Bit * 256
                                               addu r3,r3,r2		                       #Movement Ability + High Bit * 256
                                               jal 0x0005e254		                       #Store X Byte into Y (Equipment ID's)
                                               sh r3,0x0018(r17)		                   #Store Unit's Movement Ability ID
                                               lbu r2,0x0015(r16)		                   #Load Unit's Experience (could have raised limit to 9)
                                               nop                                         #
                                               sb r2,0x0021(r17)		                   #Store Unit's Experience
                                               lbu r2,0x0016(r16)		                   #Load Unit's Level
                                               addiu r4,r16,0x0019		                   #r4 = Pointer to Unit's Party Raw HP
                                               sb r2,0x0022(r17)		                   #Store Unit's Level 
                                               lbu r2,0x0017(r16)		                   #Load Unit's Brave
                                               addiu r5,r17,0x0072		                   #r5 = Pointer to Unit's Raw HP
                                               sb r2,0x0024(r17)		                   #Store Unit's Brave
                                               sb r2,0x0023(r17)		                   #Store Unit's Original Brave
                                               lbu r2,0x0018(r16)		                   #Load Unit's Faith
                                               ori r6,r0,0x000f		                       #Limit = 0xF
                                               sb r2,0x0026(r17)		                   #Store Unit's Faith
                                               jal 0x0005e254	     	                   #Store X Byte into Y (Raw Stats)
                                               sb r2,0x0025(r17)		                   #Store Unit's Original Faith
                                               addu r4,r0,r0                               #Counter = 0
                                               addu r3,r17,r4		                       #r3 = Unit's Data Pointer + Counter
@IUBD.job_unlock_loop:                         addu r2,r16,r4		                       #r2 = Unit's Party Data Pointer + Counter
                                               lbu r2,0x0028(r2)		                   #Load Unit's Unlocked Jobs
                                               addiu r4,r4,0x0001		                   #Counter ++
                                               sb r2,0x0096(r3)                            #Store Unit's Unlocked Jobs
                                               slti r2,r4,0x0003		                   #(could add this to below)
                                               bne r2,r0, @IUBD.job_unlock_loop            #Branch if Counter < 3
                                               addu r3,r17,r4                              #r3 = Unit's Data Pointer + Counter
                                               addiu r4,r16,0x002b		                   #r4 = Unit's Party Action Abilities
                                               addiu r5,r17,0x0099		                   #r5 = Unit's Action Abilities
                                               jal 0x0005e254		                       #Store X Byte into Y (Job Abilities)
                                               ori r6,r0,0x0039		                       #Limit = 0x39 (Limit = 9c would also work, including above)
                                               addiu r4,r16,0x0064		                   #r4 = Unit's Party Job Levels
                                               addiu r5,r17,0x00d2		                   #r5 = Unit's Job Levels
                                               jal 0x0005e254		                       #Store X Byte into Y (Job Levels)
                                               ori r6,r0,0x000a		                       #Limit = 0xa
                                               addiu r4,r16,0x006e		                   #r4 = Unit's Party JP
                                               addiu r5,r17,0x00dc		                   #r5 = Unit's JP
                                               jal 0x0005e254		                       #Store X Byte into Y (JP/Total JP)
                                               ori r6,r0,0x0050		                       #Limit = 0x50
                                               addiu r4,r16,0x00be		                   #r4 = Unit's Party Name
                                               addiu r5,r17,0x012c		                   #r5 = Unit's Name
                                               jal 0x0005e254		                       #Store X Byte into Y (Unit's Name)
                                               ori r6,r0,0x0010		                       #Limit = 0x10
                                               addiu r4,r17,0x0165		                   #r4 = Unit's ENTD AI Data
                                               ori r5,r0,0x0007		                       #Limit = 7
                                               lbu r2,0x00cf(r16)		                   #Load Unit's Name ID (high bit)
                                               lbu r3,0x00ce(r16)		                   #Load Unit's Name ID
                                               sll r2,r2,0x08		                       #High Bit * 256
                                               addu r3,r3,r2		                       #Name ID + High Bit * 256
                                               jal 0x0005e644		                       #Data Nullifying (ENTD AI Data)
                                               sh r3,0x016c(r17)		                   #Store Unit's Name ID
                                               lw r31,0x0018(r29)                          #
                                               lw r17,0x0014(r29)                          #
                                               lw r16,0x0010(r29)                          #
                                               addiu r29,r29,0x0020                        #
                                               jr r31                                      #
                                               nop                                         #
#/code
											   
										@Calculate_ENTD_Unit_Jobs:   #CEUJ # 0x0005b2b4  #code
                                               addiu r29,r29,0xffe0                        #
                                               sw r16,0x0010(r29)                          #
                                               addu r16,r4,r0		                       #r16 = Unit's Data Pointer
                                               sw r17,0x0014(r29)                          #
                                               addu r17,r5,r0		                       #r17 = ENTD Pointer
                                               addiu r4,r16,0x00d2	                       #	r4 = Unit's Job Level Pointer
                                               sw r31,0x0018(r29)                          #
                                               jal 0x0005e644		                       #Data Nullifying (Job Levels)
                                               ori r5,r0,0x000a		                       #Limit = 10
                                               bne r17,r0, @CEUJ.entd_unit?	               #Branch if ENTD Pointer exists
                                               addu r5,r0,r0		                       #r5 = 0
                                               jal @Job_Data_To_Unit_Data		                       #Transfer Job's Data to Unit's Data
                                               addu r4,r16,r0		                       #r4 = Unit's Data Pointer
                                               addiu r4,r16,0x0096	                       #r4 = Pointer to Unit's Unlocked Jobs
                                               addu r5,r0,r0		                       #r5 = 0
                                               ori r2,r0,0x0020		                       #r2 = 0x20
                                               sb r0,0x0013(r16)	                       #Store Unit's Secondary Skillset = 0
                                               jal 0x0005ded8		                       #Store 3-Byte Data (Unlocked Jobs = 0)
                                               sb r2,0x0006(r16)	                       #Store Unit's Gender = Monster
                                               j @CEUJ.end                                 #
                                               nop                                         #
@CEUJ.entd_unit?:                              lbu r10,0x0001(r17)	                       #Load ENTD's Gender Byte
                                               nop                                         #
                                               andi r2,r10,0x0020                          #
                                               bne r2,r0, @CEUJ.skip_job_unlocks		   #Branch if Unit is a Monster
                                               nop                                         #
                                               lbu r6,0x0008(r17)		                   #Load ENTD's Job Unlocked
                                               nop                                         #
                                               andi r7,r6,0x00ff                           #
                                               sltiu r2,r7,0x0014                          #
                                               beq r2,r0, @CEUJ.skip_job_unlocks		   #Branch if Job Unlocked is Invalid
                                               nop                                         #
                                               lbu r2,0x0009(r17)		                   #Load ENTD's Job Level
                                               nop                                         #
                                               andi r3,r2,0x000f                           #
                                               andi r2,r6,0x0001                           #
                                               bne r2,r0, @CEUJ.low_nybble                 #Branch if Job Unlocked is odd (low nybble job)
                                               addu r4,r3,r0		                       #r4 = Job Level
                                               sll r4,r3,0x04		                       #Job Level * 16
@CEUJ.low_nybble:                              srl r2,r7,0x01		                       #Job Unlocked / 2 (Job Byte)
                                               addu r2,r16,r2                              #
                                               sb r4,0x00d2(r2)		                       #Store Job Unlocked
                                               addu r6,r0,r0		                       #Counter = 0
                                               addu r9,r7,r0		                       #r9 = Job Unlocked
                                               lui r3,0x8006                               #
                                               addiu r3,r3,0x60ba	                       #r3 = Job Unlock Requirements
                                               sll r2,r9,0x02		                       #Job Unlocked * 4
                                               addu r2,r2,r9		                       #Job Unlocked * 5
                                               sll r2,r2,0x01		                       #Job Unlocked * 10
                                               addu r8,r2,r3                               #
@CEUJ.job_lvl_loop:                            beq r9,r0, @CEUJ.base_job		           #Branch if Job Unlocked = Base
                                               addu r7,r16,r6		                       #r7 = Unit's Data Pointer + Counter
                                               lbu r4,0x0000(r8)                           #Load Required Job Levels
                                               j @CEUJ.load_job_levels                     #
                                               nop                                         #
@CEUJ.base_job:                                beq r6,r0, @CEUJ.counter=0                  #Branch if Counter = 0
                                               ori r4,r0,0x0001		                       #Job Levels = 0x01
                                               ori r4,r0,0x0011		                       #Job Levels = 0x11
@CEUJ.counter=0:                               addu r7,r16,r6		                       #r7 = Unit's Data Pointer + Counter
@CEUJ.load_job_levels:                         lbu r2,0x00d2(r7)                           #Load Unit's Job Levels
                                               nop                                         #
                                               or r3,r4,r2			                       #Enable Job Levels
                                               andi r2,r3,0x000f                           #
                                               bne r2,r0, @CEUJ.low_nybble_skip            #Branch if Low Nybble Job Level != 0
                                               addu r4,r3,r0		                       #r4 = Required Job Level
                                               ori r4,r3,0x0001		                       #Low Nybble Job Level = 1
@CEUJ.low_nybble_skip:                         andi r2,r4,0x00f0                           #
                                               bne r2,r0, @CEUJ.high_nybble_skip           #Branch if High Nybble Job Level != 0
                                               addiu r8,r8,0x0001		                   #Pointer ++
                                               ori r4,r4,0x0010                            #High Nybble Job Level = 1
@CEUJ.high_nybble_skip:                        addiu r6,r6,0x0001		                   #Counter ++
                                               slti r2,r6,0x000a                           #
                                               bne r2,r0, @CEUJ.job_lvl_loop               #Branch if Counter < 10
                                               sb r4,0x00d2(r7)                            #Store Unit's new Job Levels
                                               andi r2,r10,0x0040                          #
                                               beq r2,r0, @CEUJ.not_female		           #Branch if Unit isn't a Female
                                               andi r2,r10,0x0080                          #
                                               lbu r2,0x00da(r16)		                   #Load Unit's Bard Job Level
                                               nop                                         #
                                               andi r2,r2,0x00f0		                   #Bard Level = 0
                                               sb r2,0x00da(r16)		                   #Store Unit's new Bard Level
                                               andi r2,r10,0x0080                          #
@CEUJ.not_female:                              beq r2,r0, @CEUJ.not_male                   #Branch if Unit isn't a Male
                                               addiu r4,r16,0x00d2		                   #r4 = Unit's Job Level Pointer
                                               lbu r2,0x00db(r16)		                   #Load Unit's Dancer Level
                                               nop                                         #
                                               andi r2,r2,0x000f		                   #Dancer Level = 0
                                               sb r2,0x00db(r16)		                   #Store Unit's new Dancer Level
@CEUJ.not_male:                                jal @Calculate_Unlocked_Jobs                #Calculate Unlocked Jobs
                                               addu r5,r10,r0		                       #r5 = Unit's Gender Byte
                                               addu r5,r2,r0		                       #r5 = Unlocked Jobs
@CEUJ.skip_job_unlocks:                        jal 0x0005ded8		                       #Store 3-Byte Data (Unlocked Jobs)
                                               addiu r4,r16,0x0096	                       #r4 = Unit's Unlocked Jobs Pointer
                                               lbu r2,0x000a(r17)	                       #Load ENTD Job ID
                                               addu r4,r16,r0		                       #r4 = Unit's Data Pointer
                                               jal @Job_Data_To_Unit_Data		                       #Transfer Job's Data to Unit's Data
                                               sb r2,0x0003(r16)	                       #Store Unit's Job ID
                                               lbu r6,0x001d(r17)	                       #Load ENTD Primary Skillset
                                               ori r2,r0,0x00ff		                       #r2 = FF
                                               andi r3,r6,0x00ff                           #
                                               beq r3,r2, @CEUJ.skip_1st_skillset_store	   #Branch if Primary Skillset = FF (Job's)
                                               nop                                         #
                                               beq r3,r0, @CEUJ.skip_1st_skillset_store	   #Branch if Primary Skillset = 0
                                               ori r2,r0,0x00ff		                       #r2 = FF               
                                               sb r6,0x0012(r16)		                   #Store Unit's Primary Skillset
                                               sb r2,0x0189(r16)		                   #Store ? = FF
@CEUJ.skip_1st_skillset_store:                 lbu r6,0x000b(r17)		                   #Load ENTD Secondary ID
                                               ori r2,r0,0x00fe		                       #r2 = FE
                                               andi r3,r6,0x00ff		                   #r3 = Secondary ID
                                               bne r3,r2, @CEUJ.store_2nd_skillset         #Branch if Secondary ID != Random
                                               nop                                         #
                                               lbu r2,0x0006(r16)		                   #Load Unit's Gender Byte
                                               nop                                         #
                                               andi r2,r2,0x0020                           #
                                               beq r2,r0, @CEUJ.not_a_monster		       #Branch if Unit isn't a Monster
                                               nop                                         #
                                               j @CEUJ.end                                 #
                                               sb r0,0x0013(r16)                           #Store Unit's Secondary ID = 0
@CEUJ.not_a_monster:                           jal @Set_Random_Secondary_Skillset          #Sprite Set and Random Secondary Job Calculation
                                               addu r4,r16,r0		                       #r4 = Unit's Data Pointer
                                               addu r4,r2,r0		                       #r4 = Chosen Job ID
                                               andi r3,r4,0x00ff                           #
                                               beq r3,r0, @CEUJ.job_not_choosen?           #Branch if a Job wasn't chosen
                                               sll r2,r3,0x01		                       #ID * 2
                                               addu r2,r2,r3		                       #ID * 3
                                               lui r3,0x8006                               #
                                               lw r3,0x6194(r3)		                       #Load Job Data Pointer
                                               sll r2,r2,0x04		                       #ID * 48
                                               addu r2,r2,r3                               #
                                               lbu r3,0x0000(r2)	                       #Load Job's Skillset
                                               j @CEUJ.load_unit_skill_set                 #
                                               nop                                         #
@CEUJ.job_not_choosen?:                        andi r3,r4,0x00ff                           #
@CEUJ.load_unit_skill_set:                     lbu r2,0x0012(r16)                          #Load Unit's Primary Skillset ID
                                               nop                                         #
                                               bne r3,r2, @CEUJ.store_skill_set		       #Branch if Skillset != Chosen Skillset
                                               nop                                         #
                                               addu r3,r0,r0                               #Skillset = 0
@CEUJ.store_skill_set:                         j @CEUJ.end                                 #
                                               sb r3,0x0013(r16)		                   #Store Chosen Secondary Skillset
@CEUJ.store_2nd_skillset:                      sb r6,0x0013(r16)		                   #Store Secondary Skillset = ENTD Secondary Skillset
@CEUJ.end:                                     lw r31,0x0018(r29)                          #
                                               lw r17,0x0014(r29)                          #
                                               lw r16,0x0010(r29)                          #
                                               addiu r29,r29,0x0020                        #
                                               jr r31                                      #
                                               nop						                   #
#/code

										@Set_Random_Secondary_Skillset:  #SRSS  # 0x0005b500 #code
                                               addiu r29,r29,0xffd0                        #
                                               addu r8,r4,r0		                       #r8 = Unit's Data Pointer
                                               lui r6,0x0080		                       #Job Check = 0x800000
                                               sw r16,0x0028(r29)                          #
                                               addu r16,r0,r0		                       #Unlocked Job Counter = 0
                                               addu r5,r0,r0		                       #Counter = 0
                                               addiu r7,r29,0x0010	                       #r7 = Stack Pointer
                                               sw r31,0x002c(r29)                          #
                                               lbu r2,0x0096(r8)	                       #Load Unit's Unlocked Jobs 1
                                               lbu r3,0x0097(r8)	                       #Load Unit's Unlocked Jobs 2
                                               lbu r4,0x0098(r8)	                       #Load Unit's Unlocked Jobs 3
                                               sll r2,r2,0x10		                       #UJ1 * 0x10000
                                               sll r3,r3,0x08		                       #UJ2 * 0x100
                                               addu r2,r2,r3                               #
                                               addu r4,r2,r4		                       #r4 = Unlocked Jobs
@SRSS.job_loop:                                and r2,r4,r6                                #
                                               beq r2,r0, @SRSS.not_unlocked		       #Branch if Job isn't Unlocked
                                               nop                                         #
                                               bne r5,r0, @SRSS.special_sprite		       #Branch if Counter != 0
                                               addiu r3,r5,0x004a		                   #Job ID = Counter + 0x4a
                                               lbu r3,0x0000(r8)		                   #Load Unit's Sprite Set
                                               nop                                         #
                                               andi r2,r3,0x00ff                           #
                                               sltiu r2,r2,0x0080                          #
                                               bne r2,r0, @SRSS.special_sprite             #Branch if Sprite Set is Special
                                               nop                                         #
                                               ori r3,r0,0x004a		                       #Job ID = Squire
@SRSS.special_sprite:                          sb r3,0x0000(r7)		                       #Store Temp Job ID = Squire/Sprite Set ID
                                               addiu r7,r7,0x0001	                       #Stack Pointer ++
                                               addiu r16,r16,0x0001	                       #Unlocked Job Counter ++
@SRSS.not_unlocked:                            addiu r5,r5,0x0001	                       #Counter ++
                                               srl r2,r6,0x1f                              #
                                               addu r2,r6,r2                               #
                                               sra r6,r2,0x01		                       #Job Check / 2 (next job)
                                               slti r2,r5,0x0013                           #
                                               bne r2,r0, @SRSS.job_loop                   #Branch if Counter < 0x13 (Skip Mime)
                                               nop                                         #
                                               beq r16,r0, @SRSS.end                       #Branch if No Jobs are Unlocked
                                               addu r2,r0,r0                               #Skillset = 0
                                               jal @Random_Number                          #Random Number Generator
                                               nop                                         #
                                               mult r2,r16			                       #Random * Jobs Unlocked Counter
                                               mflo r2			                           #
                                               bgez r2, @SRSS.positive_result              #Branch if Random is positive
                                               srl r3,r2,0x0f                              #rand(0..(Jobs Unlocked Counter - 1))
                                               addiu r2,r2,0x7fff                          #
                                               srl r3,r2,0x0f                              #
@SRSS.positive_result:                         andi r2,r3,0x00ff                           #
                                               addu r2,r29,r2                              #r2 = Pointer to chosen Secondary
                                               lbu r2,0x0010(r2)		                   #Load Chosen Job ID
@SRSS.end:                                     lw r31,0x002c(r29)                          #
                                               lw r16,0x0028(r29)                          #
                                               addiu r29,r29,0x0030                        #
                                               jr r31                                      #
                                               nop                                         #
#/code											   
											   
										@Job_Data_To_Unit_Data:  #JDUD #0x0005b5dc #code
                                               addiu r29,r29,0xffe0                        #
                                               sw r16,0x0010(r29)                          #
                                               addu r16,r4,r0                              #r16 = Unit's Data Pointer
                                               sw r31,0x0018(r29)                          #
                                               sw r17,0x0014(r29)                          #
                                               lbu r3,0x0000(r16)		                   #Load Unit's Sprite Set
                                               nop                                         #
                                               sltiu r2,r3,0x004a                          #
                                               beq r2,r0, @JDUD.not_unique_sprite          #Branch if Sprite Set isn't a Special Job
                                               sll r2,r3,0x01		                       #ID * 2
                                               addu r2,r2,r3		                       #ID * 3
                                               lui r3,0x8006                               #
                                               lw r3,0x6194(r3)		                       #Load Job Data Pointer
                                               sll r2,r2,0x04		                       #ID * 48
                                               addu r2,r2,r3                               #
                                               lbu r2,0x0000(r2)	                       #Load Job's Skillset
                                               j @JDUD.skip_0_storage                      #
                                               sb r2,0x0162(r16)		                   #Store Unit's Special Skillset ID
@JDUD.not_unique_sprite:                       sb r0,0x0162(r16)		                   #Store Unit's Special Skillset ID = 0
@JDUD.skip_0_storage:                          addiu r5,r16,0x000a		                   #r5 = Unit's Innate Ability Pointer
                                               lbu r3,0x0003(r16)		                   #Load Unit's Job ID
                                               ori r6,r0,0x0008		                       #Limit = 8
                                               sll r2,r3,0x01		                       #ID * 2
                                               addu r2,r2,r3		                       #ID * 3
                                               lui r3,0x8006                               #
                                               lw r3,0x6194(r3)		                       #Load Job Data Pointer
                                               sll r2,r2,0x04		                       #ID * 48
                                               addu r17,r2,r3		                       #r17 = Unit's Job Data Pointer
                                               lbu r2,0x0000(r17)	                       #Load Job's Skillset ID
                                               addiu r4,r17,0x0001	                       #r4 = Job's Innate Ability Pointer
                                               jal 0x0005e254		                       #Store X Byte into Y (Innate Abilities)
                                               sb r2,0x0012(r16)	                       #Store Unit's Primary Skillset ID
                                               addiu r4,r17,0x0009	                       #r4 = Job's Equippable Items
                                               addiu r5,r16,0x004a	                       #r5 = Unit's Equippable Items
                                               jal 0x0005e254		                       #Store X Byte into Y (Equippable Items
                                               ori r6,r0,0x0004		                       #Limit = 4
                                               addiu r4,r17,0x000d	                       #r4 = Job's HP Growth
                                               addiu r5,r16,0x0081	                       #r5 = Unit's HP Growth
                                               jal 0x0005e254		                       #Store X Byte into Y (Stat Growths/Multipliers)
                                               ori r6,r0,0x000a		                       #Limit = 10
                                               lbu r2,0x0017(r17)	                       #Load Job's Move
                                               nop                                         #
                                               sb r2,0x003a(r16)	                       #Store Unit's Move
                                               lbu r2,0x0018(r17)	                       #Load Job's Jump
                                               nop                                         #
                                               andi r2,r2,0x007f	                       #Cap Jump at 127 (0x80 flags stepping stone)
                                               sb r2,0x003b(r16)	                       #Store Unit's Jump
                                               lbu r2,0x0018(r17)	                       #Load Job's Jump
                                               nop                                         #
                                               andi r2,r2,0x0080	                       #Get Stepping stone Flag
                                               beq r2,r0, @JDUD.not_stepping_stone_skip    #Branch if Unit isn't a stepping stone
                                               nop                                         #
                                               lhu r2,0x0048(r16)	                       #Load Unit's Y Coordinate + Flags
                                               j @JDUD.store_stepping_stone                #
                                               ori r2,r2,0x4000		                       #Enable Stepping Stone
@JDUD.not_stepping_stone_skip:                 lhu r2,0x0048(r16)	                       #Load Unit's Y Coordinate + Flags
                                               nop                                         #
                                               andi r2,r2,0xbfff	                       #Disable Stepping Stone
@JDUD.store_stepping_stone:                    sh r2,0x0048(r16)	                       #Store Unit's Y Coordinate + Flags
                                               addiu r4,r17,0x001a	                       #r4 = Job's Innate Statuses
                                               addiu r5,r16,0x004e	                       #r5 = Unit's Innate Statuses
                                               jal 0x0005e254		                       #Store X Byte into Y (Statuses)
                                               ori r6,r0,0x000f		                       #Limit = 15
                                               lbu r2,0x0005(r16)	                       #Load Unit's ENTD Flags
                                               lbu r3,0x0006(r16)	                       #Load Unit's Gender Byte
                                               andi r7,r2,0x0004                           #
                                               beq r7,r0, @JDUD.post_special_immunities	   #Branch if Unit isn't Immortal
                                               andi r6,r3,0x0009                           #
                                               beq r6,r0, @JDUD.post_special_immunities	   #Branch if Unit doesn't Load/Save Formation
                                               addu r5,r0,r0		                       #Counter = 0
                                               addiu r4,r16,0x0053		                   #r4 = Unit's Status Immunities
@JDUD.special_immunities_loop:                 beq r7,r0, @JDUD.not_immortal               #Branch if Unit isn't Immortal
                                               nop                                         #
                                               lbu r2,0x0000(r4)                           #Load Unit's Status Immunities
                                               lui r1,0x8006                               #
                                               addu r1,r1,r5                               #
                                               lbu r3,0x62e9(r1)                           #Load Immortal Immunities
                                               nop                                         #
                                               or r2,r2,r3			                       #Enable Immortal Immunities
                                               sb r2,0x0000(r4)		                       #Store Unit's new Status Immunities
@JDUD.not_immortal:                            beq r6,r0, @JDUD.not_guest_unit             #Branch if Unit doesn't Load/Save Formation
                                               nop                                         #
                                               lbu r2,0x0000(r4)                           #Load Unit's Status Immunities
                                               lui r1,0x8006                               #
                                               addu r1,r1,r5                               #
                                               lbu r3,0x62ee(r1)                           #Load Load/Save Formation Immunities
                                               nop                                         #
                                               or r2,r2,r3			                       #Enable Load/Save Formation Immunities
                                               sb r2,0x0000(r4)		                       #Store Unit's New Status Immunities
@JDUD.not_guest_unit:                          addiu r5,r5,0x0001	                       #Counter ++
                                               slti r2,r5,0x0005                           #
                                               bne r2,r0, @JDUD.special_immunities_loop    #Branch if Counter < 5
                                               addiu r4,r4,0x0001		                   #Pointer ++
@JDUD.post_special_immunities:                 addiu r4,r17,0x0029		                   #r4 = Job's Absorbed Elements
                                               addiu r5,r16,0x006d		                   #r5 = Unit's Absorbed Elements
                                               jal 0x0005e254                              #Store X Byte into Y (Elemental Resistances)
                                               ori r6,r0,0x0004                            #Limit = 4
                                               sb r0,0x0071(r16)		                   #Store Unit's Strengthened Elements = 0
                                               lbu r2,0x002d(r17)		                   #Load Job's Monster Portrait
                                               nop                                         #
                                               sb r2,0x015f(r16)		                   #Store Unit's Portrait
                                               lbu r2,0x002e(r17)		                   #Load Job's Monster Palette
                                               nop                                         #
                                               sb r2,0x0160(r16)		                   #Store Unit's Palette
                                               lbu r2,0x002f(r17)		                   #Load Job's Monster Graphic
                                               nop                                         #
                                               sb r2,0x015e(r16)		                   #Store Unit's Graphic
                                               lw r31,0x0018(r29)                          #
                                               lw r17,0x0014(r29)                          #
                                               lw r16,0x0010(r29)                          #
                                               addiu r29,r29,0x0020                        #
                                               jr r31                                      #
                                               nop						                   #
#/code
										@Enable_R/S/M_Flags:  #ERSMF # 0x0005b7a0 #code
                                               addiu r29,r29,0xffe0                        #
                                               sw r17,0x0014(r29)                          #
                                               addu r17,r4,r0		                       #r17 = Unit's Data Pointer
                                               addiu r4,r17,0x008b	                       #r4 = Unit's Data Pointer  (Reactions 1)
                                               ori r5,r0,0x000b		                       #r5 = b (Reaction -> Movement)
                                               sw r31,0x001c(r29)                          #
                                               sw r18,0x0018(r29)                          #
                                               jal 0x0005e644		                       #Data Nullifying (Reactions through  Movements)
                                               sw r16,0x0010(r29)                          #
                                               addu r18,r0,r0		                       #Counter = 0
                                               addu r16,r17,r0		                       #r16 = Unit's Data Pointer
                                               addu r4,r17,r0		                       #r4 = Unit's Data Pointer
@ERSMF.rsm_loop:                               lhu r5,0x000a(r16)	                       #Load Innate Ability 1
                                               addiu r16,r16,0x0002                        #Unit's Data Pointer += 2
                                               jal @Set_R/S/M_Flag		                   #R/S/M Flag Setting (Add Innate Abilities)
                                               addiu r18,r18,0x0001                        #Counter += 1
                                               slti r2,r18,0x0004                          #
                                               bne r2,r0, @ERSMF.rsm_loop                        #Branch if all Innates haven't been checked
                                               addu r4,r17,r0		                       #r4 = Unit's Data Pointer
                                               lhu r5,0x0014(r17)	                       #Load Unit's Reaction Ability
                                               jal @Set_R/S/M_Flag                         #R/S/M Flag Setting (Add Reaction)
                                               addu r4,r17,r0		                       #r4 = Unit's Data Pointer
                                               lhu r5,0x0016(r17)	                       #Load Unit's Support Ability
                                               jal @Set_R/S/M_Flag		                   #R/S/M Flag Setting (Add Support)
                                               addu r4,r17,r0		                       #r4 = Unit's Data Pointer
                                               lhu r5,0x0018(r17)	                       #Load Unit's Movement Ability
                                               jal @Set_R/S/M_Flag		                   #R/S/M Flag Setting (Add Movement)
                                               addu r4,r17,r0		                       #r4 = Unit's Data Pointer
                                               lw r31,0x001c(r29)                          #
                                               lw r18,0x0018(r29)                          #
                                               lw r17,0x0014(r29)                          #
                                               lw r16,0x0010(r29)                          #
                                               addiu r29,r29,0x0020                        #
                                               jr r31                                      #
                                               nop										   #
#/code
											   
										@Set_R/S/M_Flag:  #SRSMF  # 0x0005b82c #code
                                               addiu r2,r5,0xfe5a	                       #Ability + fe5a (= 0 if R/S/M)
                                               addu r3,r5,r0		                       #r3 = Ability
                                               andi r5,r2,0xffff                           #
                                               sltiu r2,r5,0x0058                          #
                                               beq r2,r0, @SRSMF.end                       #Branch if Ability is not an R/S/M Ability
                                               andi r2,r3,0xffff                           #
                                               sltiu r2,r2,0x01c6                          #
                                               beq r2,r0, @SRSMF.not_a_reaction            #Branch if Ability is not a reaction
                                               nop                                         #
                                               sh r3,0x0014(r4)		                       #Store Ability as Unit's Reaction Ability
@SRSMF.not_a_reaction:                         addiu r4,r4,0x008b	                       #	r4 = Unit's Data Pointer (1st set of Reactions)
                                               srl r2,r5,0x03		                       #Ability ID / 8
                                               addu r4,r4,r2		                       #Unit's Data Pointer + Ability ID / 8
                                               andi r5,r5,0x0007                           #
                                               ori r2,r0,0x0080		                       #r2 = 80
                                               lbu r3,0x0000(r4)	                       #r3 = Ability's R/S/M set
                                               srav r2,r2,r5		                       #r2 = R/S/M's active flag
                                               or r3,r3,r2			                       #Add Ability's R/S/M Flag to active R/S/M
                                               sb r3,0x0000(r4)		                       #Store new R/S/M
@SRSMF.end:                                    jr r31                                      #
                                               nop					                       #
#/code

										@Calculate_Actual_Stats:  #CAS # 0x0005b880 #code
                                               addu r9,r4,r0		                       #r9 = Unit's Data Pointer
                                               ori r24,r0,0x0064		                   #HP/MP Divisor = 100 (Normal Units)
                                               ori r14,r0,0x03e7		                   #Stat Cap = 999
                                               lbu r2,0x0006(r9)		                   #Load Unit's Gender Byte
                                               nop                                         #
                                               andi r2,r2,0x0004                           #
                                               beq r2,r0, @CAS.not_???                     #Branch if not ??? stats
                                               andi r13,r5,0x0001		                   #r13 = Level UP Check AND 1 (Check if storing base PA/MA/SP)
                                               ori r24,r0,0x000a		                   #HP/MP Divisor = 10 (??? Units)
                                               ori r14,r0,0xffff		                   #Stat Cap = 65535
@CAS.not_???:                                  addu r11,r0,r0		                       #Counter = 0
                                               addiu r12,r9,0x0081		                   #r12 = Unit's Data Pointer (Stat Growth)
                                               lbu r15,0x0022(r9)		                   #Load Unit's Level
                                               addiu r10,r9,0x0072		                   #r10 = Unit's Data Pointer (Raw Stat)
                                               slti r25,r15,0x0002		                   #(Could just lw, sll 0x08, srl 0x08)
@CAS.main_loop:                                lbu r2,0x0001(r10)		                   #Load Unit's Raw Stat (byte 2)
                                               lbu r4,0x0000(r10)		                   #Load Unit's Raw Stat (byte 1)
                                               lbu r3,0x0002(r10)		                   #Load Unit's Raw Stat (byte 3)
                                               sll r2,r2,0x08		                       #Byte 2 * 100h
                                               addu r4,r4,r2		                       #Byte 1 + byte 2
                                               sll r3,r3,0x10		                       #Byte 3 * 10000h
                                               bne r5,r0, @CAS.not_level_up                #Branch if Preset Value != 0 (Skip Level UP)
                                               addu r4,r4,r3		                       #r4 = Full Raw Stat
                                               lbu r3,0x0002(r9)		                   #Load Unit's Party ID
                                               ori r2,r0,0x00fe                            #
                                               bne r3,r2, @CAS.not_level_up                #Branch if Party ID isn't 0xFE (ENTD Units not in party)
                                               nop                                         #
                                               lbu r7,0x0000(r12)		                   #Load Unit's Stat Growth
                                               nop                                         #
                                               bne r7,r0, @CAS.not_0_growth                #Branch if Growth > 0
                                               addu r2,r7,r0                               #r2 = Stat Growth
                                               ori r2,r0,0x0001                            #r2 = 1 (min growth)
@CAS.not_0_growth:                             addu r7,r2,r0                               #r7 = Stat Growth
                                               ori r6,r0,0x0002                            #Level Counter = 2
                                               bne r25,r0, @CAS.not_level_up               #Branch if Unit's Level < 2
                                               addu r8,r15,r0                              #r8 = Unit's Level
                                               addu r2,r7,r6                               #r2 = Stat Growth + Level Counter
@CAS.lvl_up_loop:                              addiu r2,r2,0xffff		                   #r2 = Stat Growth + Level Counter - 1 (Previous Level)
                                               divu r4,r2                                  #Raw Stat / Stat Growth
                                               mflo r2                                     #r2 = Raw Stat / Stat Growth (Raw Stat Bonus)
                                               addiu r6,r6,0x0001		                   #Level Counter += 1
                                               addu r4,r4,r2                               #Raw Stat += Raw Stat Bonus
                                               slt r2,r8,r6                                #
                                               beq r2,r0, @CAS.lvl_up_loop		           #Branch if Unit's Level > Level Counter
                                               addu r2,r7,r6		                       #r2 = Stat Growth + Level Counter
@CAS.not_level_up:                             lui r2,0x00ff                               #
                                               ori r2,r2,0xffff		                       #r2 = ffffff
                                               sltu r2,r2,r4                               #
                                               beq r2,r0, @CAS.skip_max_stat               #Branch if Raw Stat <= ffffff
                                               ori r7,r0,0x0064		                       #Raw Divisor = 100 (SP/PA/MA)
                                               lui r4,0x00ff                               #
                                               ori r4,r4,0xffff		                       #Raw Stat = ffffff (Max Stat)
@CAS.skip_max_stat:                            srl r2,r4,0x08		                       #Raw Stat / 256
                                               sb r2,0x0001(r10)                           #Store Raw Stat's 2nd Byte
                                               srl r2,r4,0x10		                       #Raw Stat / 65536
                                               slti r6,r11,0x0002	                       #(Could sh, srl 0x10, sb)
                                               sb r4,0x0000(r10)	                       #Store Raw Stat's 1st byte
                                               sb r2,0x0002(r10)	                       #Store Raw Stat's 3rd byte
                                               lbu r2,0x0001(r12)	                       #Load Unit's Stat Multiplier
                                               beq r6,r0, @CAS.1st_not_hp_mp	           #Branch if Counter >= 2 (Not HP/MP)
                                               mult r4,r2			                       #Raw Stat * Stat Multiplier
                                               addu r7,r24,r0		                       #Raw Divisor = HP/MP Divisor
@CAS.1st_not_hp_mp:                            mflo r2			                           #r2 = Raw Stat * Stat Multiplier
                                               nop                                         #
                                               nop                                         #
                                               divu r2,r7			                       #Raw Stat * Stat Multiplier / Raw Divisor
                                               mflo r2		    	                       #r2 = Raw Stat * Stat Multiplier / Raw Divisor
                                               nop                                         #
                                               srl r4,r2,0x0e		                       #Actual Stat = Raw * Multiplier / Raw Divisor / 16384
                                               bne r4,r0, @CAS.skip_min_stat               #Branch if Actual Stat > 0
                                               nop                                         #
                                               ori r4,r0,0x0001		                       #Actual Stat = 1
@CAS.skip_min_stat:                            beq r6,r0, @CAS.2nd_not_hp_mp               #Branch if Counter >= 2 (Not HP/MP)
                                               sltu r2,r14,r4                              #
                                               beq r2,r0, @CAS.skip		                   #Branch if Stat Cap > Actual Stat
                                               ori r2,r0,0x0002                            #r2 = 2
                                               addu r4,r14,r0                              #Actual Stat = Stat Cap
@CAS.2nd_not_hp_mp:                            ori r2,r0,0x0002                            #r2 = 2
@CAS.skip:                                     bne r11,r2, @CAS.pa_ma_check                #Branch if Counter != 2 (Speed)
                                               slti r2,r11,0x0003                          #
                                               sltiu r2,r4,0x0033                          #
                                               bne r2,r0, @CAS.pa_ma_check                 #Branch if Actual Stat < 51
                                               slti r2,r11,0x0003                          #
                                               ori r4,r0,0x0032		                       #Actual Stat = 50 (Speed Cap)
@CAS.pa_ma_check:                              bne r2,r0, @CAS.store_new_stat              #Branch if Counter < 3 (Not PA/MA)
                                               sltiu r2,r11,0x0005                         #
                                               sltiu r2,r4,0x0064                          #
                                               bne r2,r0, @CAS.store_new_stat              #Branch if Actual Stat < 100
                                               sltiu r2,r11,0x0005                         #
                                               ori r4,r0,0x0063                            #Actual Stat = 99 (PA/MA Cap)
@CAS.store_new_stat:                           beq r2,r0, @CAS.check_next_stat             #Branch if Counter < 5
                                               sll r2,r11,0x02                             #Counter * 4
                                               lui r1,0x8006                               #
                                               addu r1,r1,r2                               #
                                               lw r2,-0x67e8(r1)		                   #Load Level UP Stat Storing Code Pointer
                                               nop                                         #
                                               jr r2                                       #
                                               nop                                         #
@CAS.store_new_hp:                             bne r5,r0, @CAS.check_next_stat		       #Branch if Not Leveling UP (Initializing ENTD units)
                                               sh r4,0x002a(r9)		                       #Store New Max HP
                                               j @CAS.check_next_stat			           #(Max HP/MP are always set)
                                               sh r4,0x0028(r9)		                       #Store New Current HP
@CAS.store_new_mp:                             bne r5,r0, @CAS.check_next_stat             #Branch if Not Leveling UP
                                               sh r4,0x002e(r9)		                       #Store New Max MP
                                               j @CAS.check_next_stat                      #
                                               sh r4,0x002c(r9)		                       #Store New Current MP
@CAS.store_new_sp:                             bne r13,r0, @CAS.check_next_stat            #Branch if Not storing base PA/MA/SP
                                               nop                                         #(Leveling UP sets these as well)
                                               j @CAS.check_next_stat                      #
                                               sb r4,0x0032(r9)		                       #Store New Original SP
@CAS.store_new_pa:                             bne r13,r0, @CAS.check_next_stat            #Branch if Not storing base PA/MA/SP
                                               nop                                         #
                                               j @CAS.check_next_stat                      #
                                               sb r4,0x0030(r9)		                       #Store New Original PA
@CAS.store_new_ma:                             bne r13,r0, @CAS.check_next_stat	           #Branch if Not storing base PA/MA/SP
                                               nop                                         #
                                               sb r4,0x0031(r9)		                       #Store New Original MA
@CAS.check_next_stat:                          addiu r12,r12,0x0002		                   #Stat Growth Pointer += 2
                                               addiu r11,r11,0x0001		                   #Counter ++
                                               slti r2,r11,0x0005                          #
                                               bne r2,r0, @CAS.main_loop		           #Branch if Counter < 5
                                               addiu r10,r10,0x0003                        #Raw Stat Pointer += 3
                                               jr r31                                      #
                                               nop								           #
#/code
										@Calculate_Unit_Abilities:  #CUA  # 0x0005ba70 #code
                                               addiu r29,r29,0xffc0                        #
                                               sw r18,0x0020(r29)                          #
                                               addu r18,r4,r0		                       #r18 = Unit's Data Pointer
                                               sw r31,0x003c(r29)                          #
                                               sw r30,0x0038(r29)                          #
                                               sw r23,0x0034(r29)                          #
                                               sw r22,0x0030(r29)                          #
                                               sw r21,0x002c(r29)                          #
                                               sw r20,0x0028(r29)                          #
                                               sw r19,0x0024(r29)                          #
                                               sw r17,0x001c(r29)                          #
                                               sw r16,0x0018(r29)                          #
                                               lbu r8,0x0003(r18)                          #Load Unit's Job ID
                                               addu r22,r5,r0		                       #r22 = ENTD Pointer
                                               sb r8,0x0010(r29)                           #Temp Store Unit's Job ID
                                               lbu r23,0x0006(r18)                         #Load Unit's Gender Byte
                                               bne r22,r0, @CUA.skip                       #Branch if ENTD Pointer Exists
                                               ori r2,r0,0x00ff		                       #r2 = FF
                                               addiu r4,r18,0x0014	                       #r2 = Unit's Reaction Ability Pointer
                                               jal 0x0005e644		                       #Data Nullifying (R/S/M)
                                               ori r5,r0,0x0006		                       #Limit = 6
                                               j @CUA.end                                  #
                                               nop                                         #
@CUA.skip:                                     lbu r19,0x001d(r22)		                   #Load ENTD Primary Skillset
                                               nop                                         #
                                               andi r3,r19,0x00ff                          #
                                               beq r3,r2, @CUA.load_skillset               #Branch if Skillset = FF (Job's)
                                               nop                                         #
                                               beq r3,r0, @CUA.load_skillset               #Branch if Skillset = 0
                                               nop                                         #
                                               j @CUA.gender_check                         #
                                               sb r19,0x0012(r18)		                   #Store Unit's Primary Skillset
@CUA.load_skillset:                            lbu r8,0x0010(r29)		                   #Load Temp Stored Job ID
                                               lui r3,0x8006                               #
                                               lw r3,0x6194(r3)		                       #Load Job Data Pointer
                                               sll r2,r8,0x01		                       #ID * 2
                                               addu r2,r2,r8		                       #ID * 3
                                               sll r2,r2,0x04		                       #ID * 48
                                               addu r2,r2,r3                               #
                                               lbu r2,0x0000(r2)	                       #Load Job's Skillset
                                               nop                                         #
                                               sb r2,0x0012(r18)	                       #Store Unit's Primary = Job's Skillset
@CUA.gender_check:                             andi r2,r23,0x00c0                          #
                                               beq r2,r0, @CUA.load_job_data               #Branch if Unit doesn't have a Gender
                                               addiu r4,r18,0x0099	                       #r4 = Unit's Known Ability Pointer
                                               jal 0x0005e644		                       #Data Nullifying (Known Abilities)
                                               ori r5,r0,0x0039		                       #Limit = 0x39
                                               addu r17,r0,r0		                       #Counter = 0
                                               lui r30,0x8006                              #
                                               addiu r30,r30,0x6182	                       #r30 = Level 0 JP Req Pointer
                                               addu r20,r18,r0		                       #r20 = Unit's Data Pointer
                                               addu r21,r0,r0		                       #Job Counter = 0
@CUA.job_lvl_loop:                             addu r2,r18,r17		                       #r2 = Unit's Data Pointer + Counter
                                               lbu r19,0x00d2(r2)	                       #Load Unit's Job Levels
                                               ori r2,r0,0x0009		                       #r2 = 9
                                               bne r17,r2, @CUA.not_dancer                 #Branch if Counter != 9 (Dancer Check)
                                               srl r16,r19,0x04		                       #Job Level / 16 (get High Nybble Job Level)
                                               andi r2,r23,0x0080                          #
                                               bne r2,r0, @CUA.load_entd_data              #Branch if Unit is a Male
                                               addu r2,r0,r0		                       #JP = 0
@CUA.not_dancer:                               beq r16,r0, @CUA.job_lvl_skip               #Branch if High Nybble Job Level = 0
                                               nop                                         #
                                               jal @Random_Number                          #Random Number Generator
                                               nop                                         #
                                               sll r3,r2,0x01		                       #Random * 2
                                               addu r3,r3,r2		                       #Random * 3
                                               sll r3,r3,0x03		                       #Random * 24
                                               addu r3,r3,r2		                       #Random * 25
                                               sll r4,r3,0x02		                       #Random * 100
                                               sll r2,r16,0x01		                       #Dancer Job Level
                                               bgez r4, @CUA.1st_positive_result           #Branch if Random is positive
                                               addu r2,r2,r30		                       #Job Level + Job Req. Pointer
                                               addiu r4,r4,0x7fff                          #
@CUA.1st_positive_result:                      lhu r3,0x0000(r2)	                       #	Load JP Requirement
                                               sra r2,r4,0x0f		                       #rand(0..99)
                                               j @CUA.load_entd_data                       #
                                               addu r2,r3,r2		                       #JP = JP Requirement + rand(0..99)
@CUA.job_lvl_skip:                             jal @Random_Number                          #Random Number Generator
                                               nop                                         #
                                               sll r3,r2,0x01                              #
                                               addu r3,r3,r2                               #
                                               sll r3,r3,0x03                              #
                                               addu r3,r3,r2                               #
                                               sll r2,r3,0x02		                       #Random * 100
                                               bgez r2, @CUA.2nd_positive_result           #Branch if Random is Positive
                                               nop                                         #
                                               addiu r2,r2,0x7fff                          #
@CUA.2nd_positive_result:                      sra r2,r2,0x0f		                       #rand(0..99)
                                               addiu r2,r2,0x0064	                       #JP = 100 + rand(0..99)
@CUA.load_entd_data:                           addu r4,r18,r0		                       #r4 = Unit's Data Pointer
                                               addiu r5,r21,0x004a	                       #r5 = Job Counter + 0x4a 
                                               addu r6,r22,r0		                       #r6 = ENTD Pointer
                                               sh r2,0x0104(r20)	                       #Store Unit's Total JP
                                               jal @Calculate_Learned_Abilities            #Calculate Learned Abilities
                                               sh r2,0x00dc(r20)	                       #Store Unit's JP
                                               ori r2,r0,0x0008		                       #r2 = 8
                                               bne r17,r2, @CUA.not_bard                   #Branch if Counter != 8 (Bard Check)
                                               andi r16,r19,0x000f	                       #r16 = Low Nybble Job Level
                                               andi r2,r23,0x0040                          #
                                               bne r2,r0, @CUA.store_jp                    #Branch if Unit is Female
                                               addu r2,r0,r0		                       #JP = 0
@CUA.not_bard:                                 beq r16,r0, @CUA.get_random                 #Branch if Job Level = 0
                                               nop                                         #
                                               jal @Random_Number		                   #Random Number Generator
                                               nop                                         #
                                               sll r3,r2,0x01                              #
                                               addu r3,r3,r2                               #
                                               sll r3,r3,0x03                              #
                                               addu r3,r3,r2                               #
                                               sll r4,r3,0x02		                       #Random * 100
                                               sll r2,r16,0x01		                       #Job Level * 2
                                               bgez r4, @CUA.3rd_positive_result           #Branch if Random is Positive
                                               addu r2,r2,r30		                       #Job Level + Job Level Requirements Pointer
                                               addiu r4,r4,0x7fff                          #
@CUA.3rd_positive_result:                      lhu r3,0x0000(r2)	                       #Load Job Level's JP Requirement
                                               sra r2,r4,0x0f		                       #rand(0..99)
                                               j @CUA.store_jp                             #
                                               addu r2,r3,r2		                       #JP = Job Level's JP Req. + rand(0..99)
@CUA.get_random:                               jal @Random_Number		                   #Random Number Generator
                                               nop                                         #
                                               sll r3,r2,0x01                              #
                                               addu r3,r3,r2                               #
                                               sll r3,r3,0x03                              #
                                               addu r3,r3,r2                               #
                                               sll r2,r3,0x02		                       #Random * 100
                                               bgez r2, @CUA.4th_positive_result           #Branch if Random is Positive
                                               nop                                         #
                                               addiu r2,r2,0x7fff                          #
@CUA.4th_positive_result:                      sra r2,r2,0x0f		                       #rand(0..99)
                                               addiu r2,r2,0x0064	                       #JP = rand(0..99) + 100
@CUA.store_jp:                                 sh r2,0x0106(r20)	                       #Store Unit's Total JP
                                               sh r2,0x00de(r20)	                       #Store Unit's Current JP
                                               ori r2,r0,0x0009		                       #r2 = 9
                                               beq r17,r2, @CUA.mime_branch                #Branch if Counter = 9 (Mime Check)
                                               addu r4,r18,r0		                       #r4 = Unit's Data Pointer
                                               addiu r5,r21,0x004b	                       #r5 = Job Counter + 0x4b
                                               jal @Calculate_Learned_Abilities            #Calculate Learned Abilities
                                               addu r6,r22,r0		                       #r6 = ENTD Pointer
                                               addiu r20,r20,0x0004	                       #Unit's Data Pointer += 4 (next set of JP)
                                               addiu r17,r17,0x0001	                       #Counter ++
                                               slti r2,r17,0x000a                          #
                                               bne r2,r0, @CUA.job_lvl_loop                #Branch if Counter < 10
                                               addiu r21,r21,0x0002	                       #Job Counter += 2
@CUA.mime_branch:                              lbu r3,0x001d(r22)	                       #Load ENTD Primary Skillset
                                               nop                                         #
                                               beq r3,r0, @CUA.load_job_data               #Branch if Skillset = 0
                                               ori r2,r0,0x00ff		                       #r2 = FF
                                               beq r3,r2, @CUA.load_job_data               #Branch if Skillset = Job's
                                               ori r2,r0,0x00ff		                       #r2 = FF
                                               sb r2,0x0099(r18)	                       #Store Unit's Known Abilities 1 = FF (all abilities)
                                               sb r2,0x009a(r18)	                       #Store Unit's Known Abilities 2 = FF
                                               sb r2,0x009b(r18)	                       #Store Unit's Known R/S/M = FF
@CUA.load_job_data:                            addu r17,r0,r0		                       #Counter = 0
                                               lbu r8,0x0010(r29)	                       #Load Temp Stored Job ID
                                               addu r6,r18,r0		                       #r6 = Unit's Data Pointer
                                               sll r2,r8,0x01		                       #ID * 2
                                               addu r2,r2,r8		                       #ID * 3
                                               sll r7,r2,0x04		                       #ID * 48
@CUA.job_data_store_loop:                      sll r3,r17,0x01		                       #Counter * 2
                                               lui r2,0x8006                               #
                                               lw r2,0x6194(r2)		                       #Load Job Data Pointer
                                               addu r5,r18,r17		                       #r5 = Unit's Data Pointer + Counter
                                               addu r2,r7,r2                               #
                                               addu r4,r2,r17		                       #r4 = Job's Data Pointer + Counter
                                               addiu r17,r17,0x0001	                       #Counter ++
                                               addu r2,r2,r3		                       #r2 = Job's Data Pointer + Counter * 2
                                               lbu r3,0x0002(r2)	                       #Load Innate Ability's High Bit
                                               lbu r2,0x0001(r2)	                       #Load Innate Ability
                                               sll r3,r3,0x08		                       #High Bit * 256
                                               addu r2,r2,r3		                       #r2 = Innate Ability ID
                                               sh r2,0x000a(r6)		                       #Store Unit's Innate Ability
                                               lbu r2,0x0009(r4)	                       #Load Job's Equippable Items
                                               nop                                         #
                                               sb r2,0x004a(r5)		                       #Store Unit's Equippable Items
                                               slti r2,r17,0x0004                          #
                                               bne r2,r0, @CUA.job_data_store_loop         #Branch if Counter < 4
                                               addiu r6,r6,0x0002	                       #Unit's Data Pointer += 2
                                               addu r4,r18,r0		                       #r4 = Unit's Data Pointer
                                               ori r6,r0,0x0002		                       #r6 = 2 (Reaction)
                                               lhu r5,0x000c(r22)	                       #Load ENTD Reaction
                                               jal @Calculate_Unit_RSM                     #Calculate Unit's R/S/M
                                               addu r7,r22,r0		                       #r7 = ENTD Pointer
                                               addu r4,r18,r0		                       #r4 = Unit's Data Pointer
                                               ori r6,r0,0x0004		                       #r6 = 4 (Support)
                                               sh r2,0x0014(r18)	                       #Store Unit's Reaction ID
                                               lhu r5,0x000e(r22)	                       #Load ENTD Support
                                               jal @Calculate_Unit_RSM                     #Calculate Unit's R/S/M
                                               addu r7,r22,r0		                       #r7 = ENTD Pointer
                                               addu r4,r18,r0		                       #r4 = Unit's Data Pointer
                                               ori r6,r0,0x0008		                       #r6 = 8 (Movement)
                                               sh r2,0x0016(r18)	                       #Store Unit's Support ID
                                               lhu r5,0x0010(r22)	                       #Load ENTD Movement
                                               jal @Calculate_Unit_RSM                     #Calculate Unit's R/S/M
                                               addu r7,r22,r0		                       #r7 = ENTD Pointer
                                               sh r2,0x0018(r18)	                       #Store Unit's Movement ID
@CUA.end:                                      lw r31,0x003c(r29)                          #
                                               lw r30,0x0038(r29)                          #
                                               lw r23,0x0034(r29)                          #
                                               lw r22,0x0030(r29)                          #
                                               lw r21,0x002c(r29)                          #
                                               lw r20,0x0028(r29)                          #
                                               lw r19,0x0024(r29)                          #
                                               lw r18,0x0020(r29)                          #
                                               lw r17,0x001c(r29)                          #
                                               lw r16,0x0018(r29)                          #
                                               addiu r29,r29,0x0040                        #
                                               jr r31                                      #
                                               nop					                       #
#/code						   

										@Monster_Equipment_Storing:  #MES # 0x0005bdb0 #code
                                               lbu r2,0x0015(r5)	                        #Load ENTD RH Equip
                                               ori r3,r0,0x00ff		                        #r3 = FF
                                               sb r3,0x001e(r4)		                        #Store Unit's RH Shield = FF
                                               sb r2,0x001d(r4)		                        #Store Unit's RH Weapon
                                               lbu r2,0x0016(r5)	                        #Load ENTD LH Equip
                                               sb r3,0x0020(r4)		                        #Store Unit's LH Shield = FF
                                               sb r2,0x001f(r4)		                        #Store Unit's LH Weapon
                                               lbu r2,0x0012(r5)	                        #Load ENTD Helmet
                                               nop                                          #
                                               sb r2,0x001a(r4)		                        #Store Unit's Helmet
                                               lbu r2,0x0013(r5)	                        #Load ENTD Armor
                                               nop                                          #
                                               sb r2,0x001b(r4)		                        #Store Unit's Armor
                                               lbu r2,0x0014(r5)	                        #Load ENTD Accessory
                                               jr r31                                       #
                                               sb r2,0x001c(r4)		                        #Store Unit's Accessory
#/code
										
										@Calculate_ENTD_Unit_Equipment:  #CEUE # 0x0005bdf0  #code
                                               addiu r29,r29,0xffd8                         #(messy copypasta ftl)
                                               sw r16,0x0010(r29)
                                               addu r16,r4,r0		                        #r16 = Unit's Data Pointer
                                               sw r31,0x0024(r29)                           #
                                               sw r20,0x0020(r29)                           #
                                               sw r19,0x001c(r29)                           #
                                               sw r18,0x0018(r29)                           #
                                               sw r17,0x0014(r29)                           #
                                               lbu r2,0x0006(r16)	                        #Load Unit's Gender Byte
                                               nop                                          #
                                               andi r2,r2,0x0020                            #
                                               beq r2,r0, @CEUE.not_a_monster		        #Branch if Unit isn't a monster
                                               addu r20,r5,r0		                        #r20 = ENTD Pointer
                                               jal @Monster_Equipment_Storing		        #Monster Equipment Storing
                                               nop                                          #
                                               j @CEUE.end                                  #
                                               nop                                          #
@CEUE.not_a_monster:                           ori r2,r0,0x00fe		                        #r2 = FE
                                               lbu r4,0x0015(r20)		                    #Load ENTD RH Equip
                                               lbu r17,0x0091(r16)		                    #Load Unit's Support set 3
                                               andi r18,r4,0x00ff		                    #r18 = RH Equip
                                               bne r18,r2, @CEUE.load_1st_support_set       #Branch if RH Equip isn't Random
                                               andi r2,r17,0x0002                           #
                                               beq r2,r0, @CEUE.not_two_hands		        #Branch if Unit doesn't have Two-Hands
                                               ori r5,r0,0x0080		                        #Item Type = Weapon
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               ori r6,r0,0x0004		                        #Required Flags = Two-Hands
                                               jal @Calculate_Random_Equipment		                        #Calculate Random Equipment
                                               ori r7,r0,0x00ff		                        #Chosen Type = Any
                                               addu r4,r2,r0		                        #r4 = Chosen Weapon ID
@CEUE.not_two_hands:                           andi r2,r4,0x00ff                            #
                                               bne r2,r18, @CEUE.load_1st_support_set	    #Branch if a Weapon was chosen (!= FE)
                                               andi r2,r17,0x0001                           #
                                               beq r2,r0, @CEUE.load_1st_support_set		#Branch if Unit doesn't have Two Swords
                                               ori r5,r0,0x0080		                        #Item Type = Weapons
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               ori r6,r0,0x0008		                        #Required Flags = 2 Swords
                                               jal @Calculate_Random_Equipment		                        #Calculate Random Equipment
                                               ori r7,r0,0x00ff		                        #Chosen Type = Any
                                               addu r4,r2,r0		                        #r4 = Chosen Weapon ID
@CEUE.load_1st_support_set:                    lbu r17,0x008f(r16)	                        #Load Unit's Support set 1
                                               andi r19,r4,0x00ff	                        #r19 = Chosen Weapon ID
                                               ori r2,r0,0x00fe                             #
                                               bne r19,r2, @CEUE.item_choosen               #Branch if a Weapon was chosen
                                               andi r2,r4,0x00ff                            #r2 = Chosen Weapon ID
                                               andi r2,r17,0x0020                           #
                                               beq r2,r0, @CEUE.not_equip_swords            #Branch if Unit doesn't have Equip Swords
                                               ori r5,r0,0x0080		                        #Item Type = Weapons
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               addu r6,r0,r0		                        #Required Flags = None
                                               jal @Calculate_Random_Equipment		                        #Calculate Random Equipment
                                               ori r7,r0,0x0003		                        #Chosen Type = Swords
                                               addu r4,r2,r0		                        #r4 = Chosen Weapon ID
@CEUE.not_equip_swords:                        andi r18,r4,0x00ff                           #r18 = Chosen Weapon ID
                                               bne r18,r19, @CEUE.item_choosen              #Branch if a Weapon was chosen
                                               andi r2,r4,0x00ff		                    #r2 = Chosen Weapon ID
                                               andi r2,r17,0x0010                           #
                                               beq r2,r0, @CEUE.not_equip_katana            #Branch if Unit doesn't have Equip Katana
                                               ori r5,r0,0x0080		                        #Item Type = Weapons
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               addu r6,r0,r0		                        #Required Flags = None
                                               jal @Calculate_Random_Equipment		                        #Calculate Random Equipment
                                               ori r7,r0,0x0005		                        #Chosen Type = Katanas
                                               addu r4,r2,r0		                        #r4 = Chosen Weapon ID
@CEUE.not_equip_katana:                        andi r19,r4,0x00ff	                        #r19 = Chosen Weapon ID
                                               bne r19,r18, @CEUE.item_choosen              #Branch if a Weapon was chosen
                                               andi r2,r4,0x00ff		                    #r2 = Chosen Weapon ID
                                               andi r2,r17,0x0008                           #
                                               beq r2,r0, @CEUE.not_equip_crossbow          ##Branch if Unit doesn't have Equip Crossbow
                                               ori r5,r0,0x0080		                        #Item Type = Weapons
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               addu r6,r0,r0		                        #Required Flags = None
                                               jal @Calculate_Random_Equipment		                        #Calculate Random Equipment
                                               ori r7,r0,0x000b		                        #Chosen Type = Crossbow
                                               addu r4,r2,r0		                        #r4 = Chosen Weapon ID
@CEUE.not_equip_crossbow:                      andi r18,r4,0x00ff	                        #r18 = Chosen Weapon ID
                                               bne r18,r19, @CEUE.item_choosen              #Branch if a Weapon was chosen
                                               andi r2,r4,0x00ff		                    #r2 = Chosen Weapon ID
                                               andi r2,r17,0x0004                           #
                                               beq r2,r0, @CEUE.not_equip_spear             #Branch if Unit doesn't have Equip Spear
                                               ori r5,r0,0x0080		                        #Item Type = Weapons
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               addu r6,r0,r0		                        #Required Flags = None
                                               jal @Calculate_Random_Equipment		                        #Calculate Random Equipment
                                               ori r7,r0,0x000f		                        #Chosen Type = Polearm
                                               addu r4,r2,r0		                        #r4 = Chosen Weapon ID
@CEUE.not_equip_spear:                         andi r19,r4,0x00ff	                        #r19 = Chosen Weapon ID
                                               bne r19,r18, @CEUE.item_choosen	            #Branch if a Weapon was chosen
                                               andi r2,r4,0x00ff	                        #r2 = Chosen Weapon ID
                                               andi r2,r17,0x0002                           #
                                               beq r2,r0, @CEUE.not_equip_axe               #Branch if Unit doesn't have Equip Axe
                                               ori r5,r0,0x0080		                        #Item Type = Weapons
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               addu r6,r0,r0		                        #Required Flags = None
                                               jal @Calculate_Random_Equipment		                        #Calculate Random Equipment
                                               ori r7,r0,0x0006		                        #Chosen Type = Axes
                                               addu r4,r2,r0		                        #r4 = Chosen Weapon ID
@CEUE.not_equip_axe:                           andi r18,r4,0x00ff	                        #r18 = Chosen Weapon ID
                                               bne r18,r19, @CEUE.item_choosen              #Branch if a Weapon was chosen
                                               andi r2,r4,0x00ff                            #r2 = Chosen Weapon ID
                                               andi r2,r17,0x0001                           #
                                               beq r2,r0, @CEUE.not_equip_gun               #Branch if Unit doesn't have Equip Gun
                                               ori r5,r0,0x0080		                        #Item Type = Weapons
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               addu r6,r0,r0		                        #Required Flags = None
                                               jal @Calculate_Random_Equipment		                        #Calculate Random Equipment
                                               ori r7,r0,0x000a		                        #Chosen Type = Guns
                                               addu r4,r2,r0		                        #r4 = Chosen Weapon ID
@CEUE.not_equip_gun:                           andi r17,r4,0x00ff	                        #r17 = Chosen Weapon ID
                                               bne r17,r18, @CEUE.item_choosen	            #Branch if a Weapon was Chosen
                                               andi r2,r4,0x00ff	                        #r2 = Chosen Weapon ID
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               ori r5,r0,0x0080		                        #Item Type = Weapons
                                               addu r6,r0,r0		                        #Required Flags = None
                                               jal @Calculate_Random_Equipment		                        #Calculate Random Equipment
                                               ori r7,r0,0x00ff		                        #Chosen Type = Any
                                               addu r4,r2,r0		                        #r4 = Chosen Weapon ID
                                               andi r2,r4,0x00ff	                        #r2 = Chosen Weapon ID
                                               bne r2,r17, @CEUE.2nd_item_choosen           #Branch if a weapon was Chosen
                                               sll r3,r2,0x01		                        #ID * 2
                                               ori r4,r0,0x00ff		                        #Chosen Weapon ID = Unarmed
                                               andi r2,r4,0x00ff	                        #r2 = Chosen Weapon ID
@CEUE.item_choosen:                            sll r3,r2,0x01		                        #ID * 2
@CEUE.2nd_item_choosen:                        addu r3,r3,r2                                #ID * 3
                                               sll r3,r3,0x02		                        #ID * 12
                                               lui r1,0x8006                                #
                                               addu r1,r1,r3                                #
                                               lbu r2,0x2ebb(r1)	                        #Load Chosen Weapon's Type Flags
                                               nop                                          #
                                               andi r2,r2,0x0040                            #
                                               beq r2,r0, @CEUE.not_a_shield                #Branch if Weapon isn't a Shield
                                               ori r2,r0,0x00ff		                        #r2 = FF
                                               sb r4,0x001e(r16)	                        #Store Unit's RH Shield = Chosen Weapon ID
                                               j @CEUE.unarmed			                    #(even though a shield isn't an outcome here)
                                               sb r2,0x001d(r16)		                    #Store Unit's RH Weapon = None
@CEUE.not_a_shield:                            sb r4,0x001d(r16)		                    #Store Unit's RH Weapon = Chosen Weapon ID
                                               sb r2,0x001e(r16)		                    #Store Unit's RH Shield = None
@CEUE.unarmed:                                 ori r2,r0,0x00ff		                        #r2 = FF
                                               lbu r3,0x001d(r16)		                    #Load Unit's RH Weapon
                                               lbu r4,0x0016(r20)		                    #Load ENTD LH Equip
                                               beq r3,r2, @CEUE.load_3rd_support_set        #Branch if RH Weapon = Unarmed
                                               sll r2,r3,0x01		                        #ID * 2
                                               addu r2,r2,r3		                        #ID * 3
                                               sll r2,r2,0x02		                        #ID * 12
                                               lui r1,0x8006                                #
                                               addu r1,r1,r2                                #
                                               lbu r2,0x2ebc(r1)		                    #Load RH Weapon's Second Table ID
                                               nop                                          #
                                               sll r2,r2,0x03		                        #ID * 8
                                               lui r1,0x8006                                #
                                               addu r1,r1,r2                                #
                                               lbu r2,0x3ab9(r1)		                    #Load Weapon's Attack Flags
                                               nop                                          #
                                               andi r2,r2,0x0001                            #
                                               bne r2,r0, @CEUE.LH_unarmed                  #Branch if Weapon is Forced Two-Hands
                                               nop                                          #
                                               lbu r2,0x0091(r16)		                    #Load Unit's Support set 3
                                               nop                                          #
                                               andi r2,r2,0x0002                            #
                                               beq r2,r0, @CEUE.load_3rd_support_set		#Branch if Unit doesn't have Two-Hands
                                               nop                                          #
@CEUE.LH_unarmed:                              ori r4,r0,0x00ff		                        #LH Equip = FF
@CEUE.load_3rd_support_set:                    lbu r17,0x0091(r16)	                        #Load Unit's Support Set 3
                                               andi r3,r4,0x00ff	                        #r3 = LH Equip
                                               ori r2,r0,0x00fe		                        #r2 = FE
                                               bne r3,r2, @CEUE.load_next_equipable_items   #Branch if LH Equip is Random
                                               andi r2,r17,0x0001                           #
                                               beq r2,r0, @CEUE.load_next_equipable_items   #Branch if Unit doesn't have Two Swords
                                               ori r5,r0,0x0080		                        #Item Type = Weapon
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               ori r6,r0,0x0008		                        #Required Flags = Two Swords
                                               jal @Calculate_Random_Equipment              #Calculate Random Equipment
                                               ori r7,r0,0x00ff		                        #Chosen Type = Any
                                               addu r4,r2,r0		                        #r4 = Chosen Weapon ID
@CEUE.load_next_equipable_items:               lbu r17,0x004c(r16)	                        #Load Unit's Equippable Items set 3
                                               andi r3,r4,0x00ff	                        #r3 = Unit's Chosen Weapon
                                               ori r2,r0,0x00fe		                        #r2 = FE
                                               bne r3,r2, @CEUE.weapon_choosen              #Branch if a Weapon was chosen
                                               andi r2,r4,0x00ff	                        #r2 = Chosen Weapon ID
                                               andi r2,r17,0x0010                           #
                                               beq r2,r0, @CEUE.cant_equip_shield           #Branch if Unit can't equip Shields
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               ori r5,r0,0x0040		                        #Item Type = Shield
                                               addu r6,r0,r0		                        #Required Flags = None
                                               jal @Calculate_Random_Equipment              #Calculate Random Equipment
                                               ori r7,r0,0x00ff		                        #Chosen Type = Any
                                               j @CEUE.shield_choosen                       #
                                               addu r4,r2,r0		                        #r4 = Chosen Shield ID
@CEUE.cant_equip_shield:                       ori r4,r0,0x00ff		                        #Chosen Shield = None
@CEUE.shield_choosen:                          andi r2,r4,0x00ff	                        #r2 = Chosen Shield ID
@CEUE.weapon_choosen:                          sll r3,r2,0x01		                        #ID * 2
                                               addu r3,r3,r2		                        #ID * 3
                                               sll r3,r3,0x02		                        #ID * 12
                                               lui r1,0x8006                                #
                                               addu r1,r1,r3                                #
                                               lbu r2,0x2ebb(r1)	                        #Load Equip's Type Flags
                                               nop                                          #
                                               andi r2,r2,0x0080                            #
                                               beq r2,r0, @CEUE.not_a_weapon                #Branch if Equip isn't a Weapon
                                               ori r2,r0,0x00ff		                        #r2 = FF
                                               sb r4,0x001f(r16)	                        #Store LH Weapon ID = Chosen Weapon
                                               j @CEUE.no_shield                            #
                                               sb r2,0x0020(r16)		                    #Store LH Shield = None
@CEUE.not_a_weapon:                            sb r4,0x0020(r16)		                    #Store LH Shield = Chosen Shield
                                               sb r2,0x001f(r16)		                    #Store LH Weapon = None
@CEUE.no_shield:                               ori r2,r0,0x00fe		                        #r2 = FE
                                               lbu r4,0x0012(r20)		                    #Load ENTD Helmet
                                               lbu r17,0x008f(r16)		                    #Load Unit's Support Set 1
                                               andi r19,r4,0x00ff		                    #r19 = ENTD Helmet
                                               bne r19,r2, @CEUE.store_helmet               #Branch if Helmet isn't Random
                                               andi r2,r17,0x0080                           #
                                               beq r2,r0, @CEUE.not_equip_armor             #Branch if Unit doesn't have Equip Armor
                                               ori r5,r0,0x0020		                        #Item Type = Headgear
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               addu r6,r0,r0		                        #Required Flags = None
                                               jal @Calculate_Random_Equipment              #Calculate Random Equipment
                                               ori r7,r0,0x0014		                        #Chosen Type = Heavy Helms
                                               addu r4,r2,r0		                        #r4 = Chosen Helmet ID
@CEUE.not_equip_armor:                         andi r18,r4,0x00ff	                        #r18 = Chosen Helmet
                                               bne r18,r19, @CEUE.store_helmet	            #Branch if a Helmet was chosen
                                               ori r5,r0,0x0020		                        #Item Type = Headgear
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               addu r6,r0,r0		                        #Required Flags = None
                                               jal @Calculate_Random_Equipment              #Calculate Random Equipment
                                               ori r7,r0,0x00ff		                        #Chosen Type = Any
                                               addu r4,r2,r0		                        #r4 = Chosen Helmet ID
                                               andi r2,r4,0x00ff	                        #r2 = Chosen Helmet
                                               bne r2,r18, @CEUE.store_helmet               #Branch if a Helmet was chosen
                                               nop                                          #
                                               ori r4,r0,0x00ff		                        #Chosen Helmet = None
@CEUE.store_helmet:                            sb r4,0x001a(r16)	                        #Store Chosen Helmet ID
                                               lbu r4,0x0013(r20)	                        #Load ENTD Armor ID
                                               ori r2,r0,0x00fe		                        #r2 = FE
                                               andi r18,r4,0x00ff	                        #r18 = Chosen ENTD Armor ID
                                               bne r18,r2, @CEUE.store_armor                #Branch if Armor isn't Random
                                               andi r2,r17,0x0040                           #
                                               beq r2,r0, @CEUE.not_equip_shield_bug        #Branch if Unit doesn't have Equip Shield (Bug, Equip Armor)
                                               ori r5,r0,0x0010		                        #Item Type = Armor
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               addu r6,r0,r0		                        #Required Flags = None
                                               jal @Calculate_Random_Equipment              #Calculate Random Equipment
                                               ori r7,r0,0x0017		                        #Chosen Type = Heavy Armor
                                               addu r4,r2,r0		                        #r4 = Chosen Armor ID
@CEUE.not_equip_shield_bug:                    andi r17,r4,0x00ff	                        #r17 = Chosen Armor
                                               bne r17,r18, @CEUE.store_armor               #Branch if an Armor was chosen
                                               ori r5,r0,0x0010		                        #Item Type = Armor
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               addu r6,r0,r0		                        #Required Flags = None
                                               jal @Calculate_Random_Equipment              #Calculate Random Equipment
                                               ori r7,r0,0x00ff		                        #Chosen Type = Any
                                               addu r4,r2,r0		                        #r4 = Chosen Armor ID
                                               andi r2,r4,0x00ff                            #r2 = Chosen Armor
                                               bne r2,r17, @CEUE.store_armor                #Branch if an Armor was chosen
                                               nop                                          #
                                               ori r4,r0,0x00ff		                        #Chosen Armor = None
@CEUE.store_armor:                             sb r4,0x001b(r16)	                        #Store Chosen Armor
                                               lbu r4,0x0014(r20)	                        #Load ENTD Accessory ID
                                               ori r2,r0,0x00fe		                        #r2 = FE
                                               andi r17,r4,0x00ff	                        #r17 = ENTD Accessory ID
                                               bne r17,r2,  @CEUE.store_accessory           #Branch if Accessory isn't Random
                                               ori r5,r0,0x0008		                        #Item Type = Accessory
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               addu r6,r0,r0		                        #Required Flags = None
                                               jal @Calculate_Random_Equipment              #Calculate Random Equipment
                                               ori r7,r0,0x00ff		                        #Chosen Type = Any
                                               addu r4,r2,r0		                        #r4 = Chosen Accessory
                                               andi r2,r4,0x00ff	                        #r2 = Chosen Accessory
                                               bne r2,r17, @CEUE.store_accessory            #Branch if an Accessory was chosen
                                               nop                                          #
                                               ori r4,r0,0x00ff		                        #Chosen Accessory = None
@CEUE.store_accessory:                         sb r4,0x001c(r16)	                        #Store Chosen Accessory
                                               addu r3,r0,r0		                        #Counter = 0
                                               ori r5,r0,0x00ff		                        #r5 = FF
                                               addu r4,r16,r3		                        #r4 = Unit's Data Pointer + Counter
@CEUE.null_item_loop:                          lbu r2,0x001a(r4)		                    #Load Unit's Equipment ID
                                               nop                                          #
                                               bne r2,r0, @CEUE.item_found                  #Branch if Equipment ID != 0
                                               addiu r3,r3,0x0001		                    #Counter ++
                                               sb r5,0x001a(r4)                             #Store Equipment ID = None
@CEUE.item_found:                              slti r2,r3,0x0007                            #
                                               bne r2,r0, @CEUE.null_item_loop              #Branch if Counter < 7
                                               addu r4,r16,r3                               #r4 = Unit's Data Pointer + Counter
@CEUE.end:                                     lw r31,0x0024(r29)                           #
                                               lw r20,0x0020(r29)                           #
                                               lw r19,0x001c(r29)                           #
                                               lw r18,0x0018(r29)                           #
                                               lw r17,0x0014(r29)                           #
                                               lw r16,0x0010(r29)                           #
                                               addiu r29,r29,0x0028                         #
                                               jr r31                                       #
                                               nop						                    #
#/code

										@Equippable_Item_Setting:  #EIS # 0x0005c27c #code
                                               lbu r3,0x008f(r4)	                        #Load Unit's 1st set of Support
                                               nop                                          #
                                               andi r2,r3,0x0080                            #
                                               beq r2,r0, @EIS.equip_shield                 #Branch if Support is not Equip Armor
                                               andi r2,r3,0x0040                            #
                                               lbu r2,0x004c(r4)	                        #Load Unit's Equippable Items set 3
                                               nop                                          #
                                               ori r2,r2,0x0009		                        #Enable Helm/Armor
                                               sb r2,0x004c(r4)		                        #Store new Equippable Items
                                               andi r2,r3,0x0040                            #
@EIS.equip_shield:                             beq r2,r0, @EIS.equip_sword                  #Branch if Support is not Equip Shield
                                               andi r2,r3,0x0020                            #
                                               lbu r2,0x004c(r4)	                        #Load Unit's Equippable Items set 3
                                               nop                                          #
                                               ori r2,r2,0x0010		                        #Enable Shield
                                               sb r2,0x004c(r4)		                        #Store New Equippable Items
                                               andi r2,r3,0x0020                            #
@EIS.equip_sword:                              beq r2,r0, @EIS.equip_katana                 #Branch if Support is not Equip Sword
                                               andi r2,r3,0x0010                            #
                                               lbu r2,0x004a(r4)	                        #Load Unit's Equippable Items set 1
                                               nop                                          #
                                               ori r2,r2,0x0010		                        #Enable Swords
                                               sb r2,0x004a(r4)		                        #Store new Equippable Items
                                               andi r2,r3,0x0010                            #
@EIS.equip_katana:                             beq r2,r0, @EIS.equip_crossbow               #Branch if Support is not Equip Katana
                                               andi r2,r3,0x0008                            #
                                               lbu r2,0x004a(r4)	                        #Load Unit's Equippable Items set 1
                                               nop                                          #
                                               ori r2,r2,0x0004		                        #Enable Katanas
                                               sb r2,0x004a(r4)		                        #Store New Equippable Items
                                               andi r2,r3,0x0008                            #
@EIS.equip_crossbow:                           beq r2,r0, @EIS.equip_spear                  #Branch if Support is not Equip Crossbow
                                               andi r2,r3,0x0004                            #
                                               lbu r2,0x004b(r4)	                        #Load Unit's Equippable Items set 2
                                               nop                                          #
                                               ori r2,r2,0x0010		                        #Enable Crossbow
                                               sb r2,0x004b(r4)		                        #Store New Equippable Items
                                               andi r2,r3,0x0004                            #
@EIS.equip_spear:                              beq r2,r0, @EIS.equip_axe                    #Branch if Support is not Equip Spear
                                               andi r2,r3,0x0002                            #
                                               lbu r2,0x004b(r4)	                        #Load Unit's Equippable Items set 2
                                               nop                                          #
                                               ori r2,r2,0x0001		                        #Enable Polearms
                                               sb r2,0x004b(r4)		                        #Store New Equippable Items
                                               andi r2,r3,0x0002                            #
@EIS.equip_axe:                                beq r2,r0, @EIS.equip_gun                    #Branch if Support is not Equip Axe
                                               andi r2,r3,0x0001                            #
                                               lbu r2,0x004a(r4)	                        #Load Unit's Equippable Items set 1
                                               nop                                          #
                                               ori r2,r2,0x0002		                        #Enable Axes
                                               sb r2,0x004a(r4)		                        #Store New Equippable Items
                                               andi r2,r3,0x0001                            #
@EIS.equip_gun:                                beq r2,r0, @EIS.female_items                 #Branch if Support is not Equip Gun
                                               nop                                          #
                                               lbu r2,0x004b(r4)	                        #Load Unit's Equippable Items set 2
                                               nop                                          #
                                               ori r2,r2,0x0020		                        #Enable Guns
                                               sb r2,0x004b(r4)		                        #Store New Equippable Items
@EIS.female_items:                             lbu r3,0x0006(r4)	                        #Load Unit's Gender
                                               nop                                          #
                                               andi r2,r3,0x0040                            #
                                               beq r2,r0, @EIS.end	                        #Branch if Unit is not Female
                                               nop                                          #
                                               lbu r2,0x004c(r4)	                        #Load Unit's Equippable Items set 3
                                               lbu r3,0x004d(r4)	                        #Load Unit's Equippable Items set 4
                                               ori r2,r2,0x0042		                        #Enable Hair Ornaments/Bags
                                               ori r3,r3,0x0001		                        #Enable Perfume
                                               sb r2,0x004c(r4)		                        #Store New Equippable Items
                                               sb r3,0x004d(r4)		                        #Store New Equippable Items
@EIS.end:                                      jr r31                                       #
                                               nop					                        #						   
																					        #
#/code

										@Equipment_Stat_Setting:  #ESS # 0x0005c398 #code
                                               addiu r29,r29,0xffe8                         #
                                               sw r16,0x0010(r29)                           #
                                               addu r16,r4,r0		                        #r16 = Unit's Data Pointer
                                               addiu r4,r16,0x003c	                        #r4 = Unit's Data Pointer (WP 1)
                                               sw r31,0x0014(r29)                           #
                                               jal 0x0005e644		                        #Data Nullifying (Equipment Stats)
                                               ori r5,r0,0x000b		                        #r5 = b (Equipment Stats)
                                               lbu r3,0x0003(r16)	                        #Load Unit's Job ID
                                               nop                                          #
                                               sll r2,r3,0x01		                        #Job ID * 2
                                               addu r2,r2,r3		                        #Job ID * 3
                                               lui r3,0x8006                                #
                                               lw r3,0x6194(r3)		                        #Load Job Data Pointer
                                               sll r2,r2,0x04		                        #Job ID * 24
                                               addu r2,r2,r3		                        #Job ID * 25
                                               lbu r3,0x0019(r2)	                        #Load Job's C-EV
                                               lbu r2,0x0006(r16)	                        #Load Unit's Gender Byte
                                               nop                                          #
                                               andi r2,r2,0x0020                            #
                                               bne r2,r0, @ESS.end	                        #Branch if Unit is a Monster
                                               sb r3,0x0043(r16)	                        #Store Job's C-EV into Unit's
@ESS.Accessory:                                lbu r2,0x001c(r16)	                        #Load Unit's Accessory ID
                                               nop                                          #
                                               sll r3,r2,0x01		                        #ID * 2
                                               addu r3,r3,r2		                        #ID * 3
                                               sll r3,r3,0x02		                        #ID * 12
                                               lui r1,0x8006                                #
                                               addu r1,r1,r3                                #
                                               lbu r2,0x2ebb(r1)	                        #Load Accessory's Item Type
                                               lui r4,0x8006                                #
                                               addiu r4,r4,0x2eb8	                        #r4 = Item Data Pointer
                                               andi r2,r2,0x0008                            #
                                               beq r2,r0, @ESS.RH_shield                    #Branch if Accessory isn't an Accessory
                                               nop                                          #
                                               lui r1,0x8006                                #
                                               addu r1,r1,r3                                #
                                               lbu r2,0x2ebc(r1)	                        #Load Accessory's Second Table ID
                                               lui r3,0x8006                                #
                                               addiu r3,r3,0x3f58	                        #r3 = Accessory Secondary Data Pointer
                                               sll r2,r2,0x01		                        #ID * 2
                                               addu r2,r2,r3                                #
                                               lbu r3,0x0000(r2)	                        #Load Accessory's P-EV
                                               nop                                          #
                                               sb r3,0x0040(r16)	                        #Store Accessory's P-EV into Unit's
                                               lbu r2,0x0001(r2)	                        #Load Accessory's M-EV
                                               nop                                          #
                                               sb r2,0x0044(r16)	                        #Store Accessory's M-EV into Unit's
@ESS.RH_shield:                                lbu r2,0x001e(r16)	                        #Load Unit's RH Shield
                                               nop                                          #
                                               sll r3,r2,0x01		                        #ID * 2
                                               addu r3,r3,r2		                        #ID * 3
                                               sll r3,r3,0x02		                        #ID * 12
                                               addu r2,r3,r4                                #
                                               lbu r2,0x0003(r2)	                        #Load Shield's Item Type
                                               nop                                          #
                                               andi r2,r2,0x0040                            #
                                               beq r2,r0, @ESS.LH_shield                    #Branch if Shield isn't a Shield
                                               nop                                          #
                                               lui r1,0x8006                                #
                                               addu r1,r1,r3                                #
                                               lbu r2,0x2ebc(r1)	                        #Load Shield's Second Table ID
                                               lui r3,0x8006                                #
                                               addiu r3,r3,0x3eb8                           #
                                               sll r2,r2,0x01		                        #ID * 2
                                               addu r3,r2,r3                                #
                                               lbu r2,0x0000(r3)	                        #Load Shield's P-EV
                                               nop                                          #
                                               sb r2,0x0041(r16)	                        #Store RH Shield's P-EV into Unit's
                                               lbu r2,0x0001(r3)	                        #Load Shield's M-EV
                                               nop                                          #
                                               sb r2,0x0045(r16)	                        #Store RH Shield's M-EV into Unit's
@ESS.LH_shield:                                lbu r2,0x0020(r16)	                        #Load Unit's LH Shield
                                               nop                                          #
                                               sll r3,r2,0x01		                        #ID * 2
                                               addu r3,r3,r2		                        #ID * 3
                                               sll r3,r3,0x02		                        #ID * 12
                                               addu r2,r3,r4                                #
                                               lbu r2,0x0003(r2)	                        #Load Shield's Item Type
                                               nop                                          #
                                               andi r2,r2,0x0040                            #
                                               beq r2,r0, @ESS.RH_weapon                    #Branch if Shield isn't a Shield
                                               nop                                          #
                                               lui r1,0x8006                                #
                                               addu r1,r1,r3                                #
                                               lbu r2,0x2ebc(r1)	                        #Load Shield's Second Table ID
                                               lui r3,0x8006                                #
                                               addiu r3,r3,0x3eb8                           #
                                               sll r2,r2,0x01		                        #ID * 2
                                               addu r3,r2,r3                                #
                                               lbu r2,0x0000(r3)	                        #Load Shield's P-EV
                                               nop                                          #
                                               sb r2,0x0042(r16)	                        #Store LH Shield's P-EV into Unit's
                                               lbu r2,0x0001(r3)	                        #Load Shield's M-EV
                                               nop                                          #
                                               sb r2,0x0046(r16)	                        #Store LH Shield's M-EV into Unit's
@ESS.RH_weapon:                                lbu r3,0x001d(r16)	                        #Load Unit's RH Weapon
                                               nop                                          #
                                               sll r2,r3,0x01		                        #ID * 2
                                               addu r2,r2,r3		                        #ID * 3
                                               sll r2,r2,0x02		                        #ID * 12
                                               addu r2,r2,r4                                #
                                               lbu r2,0x0003(r2)	                        #Load Weapon's Item Type
                                               nop                                          #
                                               andi r2,r2,0x0080                            #
                                               beq r2,r0, @ESS.LH_weapon                    #Branch if Weapon isn't a Weapon
                                               sll r3,r3,0x03		                        #Original ID * 8
                                               lui r2,0x8006                                #
                                               addiu r2,r2,0x3ab8                           #
                                               addu r3,r3,r2                                #
                                               lbu r2,0x0004(r3)	                        #Load Weapon's WP
                                               nop                                          #
                                               sb r2,0x003c(r16)	                        #Store RH Weapon's WP into Unit's
                                               lbu r2,0x0005(r3)	                        #Load Weapon's W-EV
                                               nop                                          #
                                               sb r2,0x003e(r16)	                        #Store RH Weapon's W-EV into Unit's
@ESS.LH_weapon:                                lbu r3,0x001f(r16)	                        #Load Unit's LH Weapon
                                               nop                                          #
                                               sll r2,r3,0x01		                        #ID * 2
                                               addu r2,r2,r3		                        #ID * 3
                                               sll r2,r2,0x02		                        #ID * 12
                                               addu r2,r2,r4                                #
                                               lbu r2,0x0003(r2)	                        #Load Weapon's Item Type
                                               nop                                          #
                                               andi r2,r2,0x0080                            #
                                               beq r2,r0, @ESS.end	                        #Branch if Weapon isn't a Weapon
                                               sll r3,r3,0x03		                        #Original ID * 8
                                               lui r2,0x8006                                #
                                               addiu r2,r2,0x3ab8                           #
                                               addu r3,r3,r2                                #
                                               lbu r2,0x0004(r3)	                        #Load Weapon's WP
                                               nop                                          #
                                               sb r2,0x003d(r16)	                        #Store LH Weapon's WP into Unit's
                                               lbu r2,0x0005(r3)	                        #Load Weapon's W-EV
                                               nop                                          #
                                               sb r2,0x003f(r16)	                        #Store LH Weapon's W-EV
@ESS.end:                                      lw r31,0x0014(r29)                           #
                                               lw r16,0x0010(r29)                           #
                                               addiu r29,r29,0x0018                         #
                                               jr r31                                       #
                                               nop                                          #
#/code

										@Equipment_Attribute_Setting:  #EAS # 0x0005c5c8 #code
                                               addiu r29,r29,0xffe0	                        #(Note: Level UP Check + 1 below is to prevent Level UP, and
                                               sw r17,0x0014(r29)	                        #to set the new Max HP/MP and/or PA/MA/SP)
                                               addu r17,r4,r0		                        #r17 = Unit's Data Pointer
                                               sw r16,0x0010(r29)                           #
                                               addu r16,r5,r0		                        #r16 = Level UP Check
                                               sw r18,0x0018(r29)                           #
                                               addiu r18,r17,0x0033	                        #r18 = Unit's Data Pointer (Bonus Stats)
                                               addu r4,r18,r0		                        #r4 = Unit's Data Pointer (Bonus Stats)
                                               sw r31,0x001c(r29)                           #
                                               jal 0x0005e644		                        #Data Nullifying (Bonus Stats)
                                               ori r5,r0,0x0003		                        #r5 = 3 (The three Bonus Stats)
                                               addu r4,r17,r0		                        #r4 = Unit's Data Pointer
                                               jal @Calculate_Actual_Stats                  #Calculate Actual Stats (No Level UP)
                                               addiu r5,r16,0x0001	                        #r5 = Level UP Check + 1 (1 = HP/MP/PA/MA/SP, 2 = HP/MP)
                                               lbu r2,0x0006(r17)	                        #Load Unit's Gender Byte
                                               ori r16,r0,0x03e7	                        #HP/MP Cap = 999 (This is what causes ??? to re-cap)
                                               andi r2,r2,0x0020                            #
                                               bne r2,r0, @EAS.stat_setting                 #Branch if Unit is a Monster
                                               sb r0,0x0184(r17)	                        #Unit's Equipped Flags? = 0
                                               addu r4,r18,r0		                        #r4 = Unit's Data Pointer (Bonus Stats)
                                               addu r10,r0,r0		                        #Equipment Counter = 0
                                               addu r2,r17,r10		                        #r2 = Unit's Data Pointer + Equipment's Counter
@EAS.item_loop_start:                          lbu r5,0x001a(r2)	                        #Load Unit's Equipment ID
                                               ori r2,r0,0x0020		                        #r2 = 20
                                               andi r3,r5,0x00ff	                        #r3 = Unit's Equipment ID
                                               bne r3,r2, @EAS.weapon_check                 #Branch if Item isn't Materia Blade
                                               sltiu r2,r3,0x0080                           #
                                               lbu r2,0x0184(r17)	                        #Load Unit's Equipped Flags?
                                               nop                                          #
                                               ori r2,r2,0x0004		                        #Enable Materia Blade
                                               sb r2,0x0184(r17)	                        #Store New Equipped Flags?
                                               sltiu r2,r3,0x0080                           #
@EAS.weapon_check:                             beq r2,r0, @EAS.load_attributes_start        #Branch if Item isn't a weapon
                                               sll r2,r3,0x01		                        #ID * 2
                                               addu r2,r2,r3		                        #ID * 3
                                               sll r2,r2,0x02		                        #ID * 12
                                               lui r1,0x8006                                #
                                               addu r1,r1,r2                                #
                                               lbu r2,0x2ebd(r1)	                        #Load Weapon's Item Type
                                               nop                                          #
                                               addiu r2,r2,0xfffd	                        #Item Type - 3 (Sword)
                                               sltiu r2,r2,0x0002                           #
                                               beq r2,r0, @EAS.load_attributes_start_2nd    #Branch if Weapon isn't a Sword or Knight Sword
                                               andi r3,r5,0x00ff                            #
                                               lbu r2,0x0184(r17)	                        #Load Equipped Flags?
                                               nop                                          #
                                               ori r2,r2,0x0008		                        #Enable Sword
                                               sb r2,0x0184(r17)	                        #Store new Equipped Flags?
@EAS.load_attributes_start:                    andi r3,r5,0x00ff                            #
@EAS.load_attributes_start_2nd:                ori r2,r0,0x00ff		                        #r2 = ff
                                               beq r3,r2, @EAS.prep_next_item               #Branch if nothing is equipped
                                               sll r2,r3,0x01		                        #ID * 2
                                               addu r6,r4,r0		                        #r6 = Unit's Data Pointer (Bonus Stats)
                                               addu r2,r2,r3		                        #ID * 3
                                               sll r2,r2,0x02		                        #ID * 12
                                               lui r3,0x8006                                #
                                               addiu r3,r3,0x2eb8                           #
                                               addu r9,r2,r3                                #
                                               lbu r3,0x0007(r9)	                        #Load Equipment's Item Attributes
                                               addiu r8,r4,0x0003	                        #r8 = Unit's Data Pointer (PA)
                                               sll r2,r3,0x01		                        #ID * 2
                                               addu r2,r2,r3		                        #ID * 3
                                               sll r2,r2,0x03		                        #ID * 24
                                               addu r2,r2,r3		                        #ID * 25
                                               lui r3,0x8006                                #
                                               addiu r3,r3,0x42c4                           #
                                               addu r7,r2,r3		                        #r7 = Item Attribute's Data Location
                                               addu r5,r7,r0		                        #r5 = Item Attribute's Data Location
@EAS.bonus_stat_store_loop:                    lbu r2,0x0000(r5)	                        #Load Item Attribute's Stat
                                               lbu r3,0x0000(r6)	                        #Load Unit's Bonus Stat
                                               nop                                          #
                                               addu r3,r2,r3		                        #Bonus Stat + Item Attribute's Stat
                                               sltiu r2,r3,0x0100                           #
                                               bne r2,r0, @EAS.store_bonus_stat             #Branch if new Stat < 256
                                               addiu r5,r5,0x0001	                        #Item Attribute's Data Pointer += 1
                                               ori r3,r0,0x00ff		                        #Stat = 255
@EAS.store_bonus_stat:                         sb r3,0x0000(r6)		                        #Store new Bonus Stat
                                               addiu r6,r6,0x0001	                        #Unit's Bonus Stat Pointer += 1
                                               slt r2,r6,r8                                 #
                                               bne r2,r0, @EAS.bonus_stat_store_loop        #Branch if all Bonus Stats haven't been checked
                                               nop                                          #
                                               lbu r2,0x0003(r7)	                        #Load Item Attribute's Move
                                               lbu r3,0x003a(r17)	                        #Load Unit's Move
                                               nop                                          #
                                               addu r3,r2,r3		                        #Item Attribute's Move + Unit's Move
                                               sltiu r2,r3,0x00fe                           #
                                               bne r2,r0, @EAS.move_store                   #Branch if Move < 254
                                               nop                                          #
                                               ori r3,r0,0x00fd		                        #Move = 253
@EAS.move_store:                               sb r3,0x003a(r17)	                        #Store Unit's new Move
                                               lbu r2,0x0004(r7)	                        #Load Item Attribute's Jump
                                               lbu r3,0x003b(r17)	                        #Load Unit's Jump
                                               nop                                          #
                                               addu r3,r2,r3		                        #Item Attribute's Jump + Unit's Jump
                                               sltiu r2,r3,0x0008                           #
                                               bne r2,r0, @EAS.jump_store                   #Branch if Jump < 8
                                               addu r5,r0,r0		                        #Status Counter = 0
                                               ori r3,r0,0x0007		                        #Jump = 7
@EAS.jump_store:                               sb r3,0x003b(r17)	                        #Store Unit's new Jump
                                               addiu r6,r17,0x004e	                        #r6 = Unit's Data Pointer (Innate Statuses)
@EAS.status_store_loop:                        addu r2,r7,r5		                        #r2 = Item Attribute's Pointer += Status Counter
                                               lbu r2,0x0005(r2)	                        #Load X Status set Y
                                               lbu r3,0x0000(r6)	                        #Load Unit's X Status set Y
                                               addiu r5,r5,0x0001	                        #Status Counter += 1
                                               or r2,r2,r3			                        #Combine Item and Unit's Innate Statuses
                                               sb r2,0x0000(r6)		                        #Store New Unit's Innate Statuses
                                               slti r2,r5,0x000f                            #
                                               bne r2,r0, @EAS.status_store_loop            #Branch if all statuses haven't been set
                                               addiu r6,r6,0x0001	                        #Unit's Status Pointer += 1
                                               addu r5,r0,r0		                        #Elemental Counter = 0
                                               addiu r6,r17,0x006d	                        #r6 = Unit's Data Pointer (Elemental Absorption)
@EAS.element_store_loop:                       addu r2,r7,r5		                        #r2 = Item Attribute Pointer
                                               lbu r2,0x0014(r2)	                        #Load Item Attribute's Element byte X
                                               lbu r3,0x0000(r6)	                        #Load Unit's Element byte X
                                               addiu r5,r5,0x0001	                        #Elemental Counter += 1
                                               or r2,r2,r3			                        #Combine Element Bytes
                                               sb r2,0x0000(r6)		                        #Store new Unit's Element Byte X
                                               slti r2,r5,0x0005                            #
                                               bne r2,r0, @EAS.element_store_loop           #Branch if all Element Bytes haven't been checked
                                               addiu r6,r6,0x0001	                        #Unit's Elemental Pointer += 1
                                               lbu r2,0x0003(r9)	                        #Load Equipment's Item Type
                                               nop                                          #
                                               andi r2,r2,0x0030                            #
                                               beq r2,r0, @EAS.prep_next_item               #Branch if Equipment is not a Helm/Armor
                                               nop                                          #
                                               lbu r2,0x0004(r9)	                        #Load Equipment's Second Table ID
                                               lhu r3,0x002a(r17)	                        #Load Unit's Max HP
                                               sll r5,r2,0x01		                        #ID * 2
                                               lui r1,0x8006                                #
                                               addu r1,r1,r5                                #
                                               lbu r2,0x3ed8(r1)	                        #Load Equipment's HP Bonus
                                               nop                                          #
                                               addu r3,r3,r2		                        #Max HP += HP Bonus
                                               sltu r2,r16,r3                               #
                                               beq r2,r0, @EAS.store_hp                     #Branch if HP/MP Cap >= Max HP
                                               nop                                          #
                                               addu r3,r16,r0		                        #Max HP = HP/MP Cap
@EAS.store_hp:                                 lhu r2,0x002e(r17)	                        #Load Unit's Max MP
                                               sh r3,0x002a(r17)	                        #Store new Max HP
                                               lui r1,0x8006                                #
                                               addu r1,r1,r5                                #
                                               lbu r3,0x3ed9(r1)	                        #Load Equipment's MP Bonus
                                               nop                                          #
                                               addu r3,r2,r3		                        #Max MP += MP Bonus
                                               sltu r2,r16,r3                               #
                                               beq r2,r0, @EAS.store_mp                     #Branch if HP/MP Cap >= Max MP
                                               nop                                          #
                                               addu r3,r16,r0		                        #Max MP = HP/MP Cap
@EAS.store_mp:                                 sh r3,0x002e(r17)	                        #Store new Max MP
@EAS.prep_next_item:                           addiu r10,r10,0x0001	                        #Equipment Counter += 1
                                               slti r2,r10,0x0007                           #
                                               bne r2,r0, @EAS.item_loop_start              #Branch if all equipments haven't been checked
                                               addu r2,r17,r10		                        #Equipment Pointer += 1
@EAS.stat_setting:                             lhu r3,0x0028(r17)	                        #Load Unit's Current HP
                                               lhu r2,0x002a(r17)	                        #Load Unit's Max HP
                                               nop                                          #
                                               sltu r2,r2,r3                                #
                                               beq r2,r0, @EAS.store_current_hp             #Branch if Max HP >= Current HP
                                               nop                                          #
                                               lhu r2,0x002a(r17)	                        #Load Unit's Max HP
                                               nop                                          #
                                               sh r2,0x0028(r17)	                        #Store Unit's Current HP = Max HP
@EAS.store_current_hp:                         lhu r3,0x002c(r17)	                        #Load Unit's Current MP
                                               lhu r2,0x002e(r17)	                        #Load Unit's Max MP
                                               nop                                          #
                                               sltu r2,r2,r3                                #
                                               beq r2,r0, @EAS.store_current_mp             #Branch if Max MP >= Current MP
                                               addiu r5,r17,0x0030	                        #r5 = Unit's Data Pointer (Original PA)
                                               lhu r2,0x002e(r17)	                        #Load Unit's Max MP
                                               nop                                          #
                                               sh r2,0x002c(r17)	                        #Store Unit's Current MP = Max MP
@EAS.store_current_mp:                         addiu r6,r17,0x0032	                        #r6 = Unit's Data Pointer (Original SP)
                                               addiu r4,r17,0x0033	                        #r4 = Unit's Data Pointer (Bonus PA)
@EAS.new_stat_store_loop_start:                lbu r2,0x0003(r5)	                        #Load Unit's Bonus Stat
                                               lbu r3,0x0000(r5)	                        #Load Unit's Original Stat
                                               nop                                          #
                                               addu r3,r2,r3		                        #Original Stat += Bonus Stat
                                               slt r2,r5,r6                                 #
                                               beq r2,r0, @EAS.speed_limit_check            #Branch if New Stat is Speed
                                               sltiu r2,r3,0x0064                           #
                                               bne r2,r0, @EAS.store_new_stat               #Branch if New Stat < 100
                                               nop                                          #
                                               j @EAS.store_new_stat                        #
                                               ori r3,r0,0x0063		                        #New Stat = 99
@EAS.speed_limit_check:                        andi r2,r3,0xffff                            #
                                               sltiu r2,r2,0x0033                           #
                                               bne r2,r0, @EAS.store_new_stat               #Branch if New Speed < 51
                                               nop                                          #
                                               ori r3,r0,0x0032		                        #New Speed = 50
@EAS.store_new_stat:                           sb r3,0x0006(r5)		                        #Store Unit's Actual Stat = New Stat
                                               addiu r5,r5,0x0001	                        #Stat Pointer += 1
                                               slt r2,r5,r4                                 #
                                               bne r2,r0, @EAS.new_stat_store_loop_start    #Branch if all stats haven't been set
                                               nop                                          #
                                               lw r31,0x001c(r29)                           #
                                               lw r18,0x0018(r29)                           #
                                               lw r17,0x0014(r29)                           #
                                               lw r16,0x0010(r29)                           #
                                               addiu r29,r29,0x0020                         #
                                               jr r31                                       #
                                               nop                                          #
#/code
											   
										@Move_Jump_Calculation:  #MJC #0x0005c8ec #code
                                               bne r5,r0, @MJC.load_move                    #Branch if not Setting Current HP/MP to Max
                                               nop                                          #
                                               lhu r2,0x002a(r4)	                        #Load Unit's Max HP
                                               lhu r3,0x002e(r4)	                        #Load Unit's Max MP
                                               sh r2,0x0028(r4)		                        #Store Current HP = Max HP
                                               sh r3,0x002c(r4)		                        #Store Current MP = Max MP
@MJC.load_move:                                lbu r5,0x003a(r4)	                        #Load Unit's Move
                                               lbu r6,0x0093(r4)	                        #Load Unit's 1st set of Movements
                                               lbu r3,0x003b(r4)	                        #Load Unit's Jump
                                               andi r2,r6,0x0080                            #
@MJC.move1_check:                              beq r2,r0, @MJC.move2_check                  #Branch if Unit doesn't have Move +1
                                               andi r2,r6,0x0040                            #
                                               addiu r5,r5,0x0001	                        #Move += 1
@MJC.move2_check:                              beq r2,r0, @MJC.move3_check                  #Branch if Unit doesn't have Move +2
                                               andi r2,r6,0x0020                            #
                                               addiu r5,r5,0x0002	                        #Move += 2
@MJC.move3_check:                              beq r2,r0, @MJC.jump1_check                  #Branch if Unit doesn't have Move +3
                                               andi r2,r6,0x0010                            #
                                               addiu r5,r5,0x0003	                        #Move += 3
@MJC.jump1_check:                              beq r2,r0, @MJC.jump2_check                  #Branch if Unit doesn't have Jump +1
                                               andi r2,r6,0x0008                            #
                                               addiu r3,r3,0x0001	                        #Jump += 1
@MJC.jump2_check:                              beq r2,r0, @MJC.jump3_check                  #Branch if Unit doesn't have Jump +2
                                               andi r2,r6,0x0004                            #
                                               addiu r3,r3,0x0002	                        #Jump += 2
@MJC.jump3_check:                              beq r2,r0, @MJC.move_limit                   #Branch if Unit doesn't have Jump +3
                                               andi r2,r5,0xffff                            #
                                               addiu r3,r3,0x0003	                        #Jump += 3
@MJC.move_limit:                               sltiu r2,r2,0x00fd                           #
                                               bne r2,r0, @MJC.jump_limit                   #Branch if Unit's Move < 253
                                               andi r2,r3,0xffff                            #
                                               ori r5,r0,0x00fc		                        #Move = 252
@MJC.jump_limit:                               sltiu r2,r2,0x0008                           #
                                               bne r2,r0, @MJC.end	                        #Branch if Unit's Jump < 8
                                               sb r5,0x003a(r4)		                        #Store Move
                                               ori r3,r0,0x0007		                        #Jump = 7
@MJC.end:                                      jr r31                                       #
                                               sb r3,0x003b(r4)		                        #Store Jump
#/code											   

										@Generate_Character_Names:  #GCN  #code             #
0x0005c984:                                    lui r2,0x8006                                #
                                               lw r2,0x6200(r2)		                        #Load Battle Initialization flag?
                                               addiu r29,r29,0xfec8                         #
                                               sw r18,0x0118(r29)                           #
                                               addu r18,r4,r0                               #r18 = Unit's Data Pointer
                                               sw r21,0x0124(r29)                           #
                                               lui r21,0x8013                               #
                                               addiu r21,r21,0x2824                         #r21 = Pointer to "Prep for Loading Text" Code (battle)
                                               sw r31,0x0130(r29)                           #
                                               sw r23,0x012c(r29)                           #
                                               sw r22,0x0128(r29)                           #
                                               sw r20,0x0120(r29)                           #
                                               sw r19,0x011c(r29)                           #
                                               sw r17,0x0114(r29)                           #
                                               beq r2,r0, @GNC.skip                         #Branch if not Initializing Data?
                                               sw r16,0x0110(r29)                           #
                                               lui r21,0x800e                               #
                                               addiu r21,r21,0x6edc                         #r21 = Pointer to "Prep for Loading Text" Code (world)
@GNC.skip:                                     lbu r4,0x0002(r18)                           #Load Unit's Party ID
                                               ori r2,r0,0x00ff		                        #r2 = FF
                                               bne r4,r2, @GNC.store_text_prep              #Branch if Party ID != FF (already named)
                                               nop                                          #
                                               lbu r7,0x016c(r18)	                        #Load Unit's Name ID
                                               nop                                          #
                                               bne r7,r4, @GNC.name_already_choosen         #Branch if Name ID != Party ID (name already chosen)
                                               ori r17,r0,0x4000	                        #Name Flags = 0x4000 (Special Names)
                                               lbu r3,0x0006(r18)	                        #Load Unit's Gender Byte
                                               nop                                          #
                                               andi r2,r3,0x0080                            #
                                               beq r2,r0, @GNC.female_check                 #Branch if Unit isn't a male
                                               andi r4,r3,0x00e0	                        #r4 = Unit's Gender
                                               ori r17,r0,0x4100	                        #Name Flags = 0x4100 (Generic Male Names)
                                               j @GNC.load_party_data_pointer               #
                                               ori r20,r0,0x0100	                        #Name Modifier = 0x100
@GNC.female_check:                             andi r2,r3,0x0040                            #
                                               beq r2,r0, @GNC.monster_names                #Branch if Unit isn't a Female
                                               ori r17,r0,0x4200	                        #Name Flags = 0x4200 (Generic Female Names)
                                               j @GNC.load_party_data_pointer               #
                                               ori r20,r0,0x0200	                        #Name Mod = 0x200
@GNC.monster_names:                            ori r17,r0,0x4300	                        #Name Flags = 0x4300 (Generic Monster Names)
                                               ori r20,r0,0x0300	                        #Name Mod = 0x300
@GNC.load_party_data_pointer:                  lui r23,0x8005                               #
                                               addiu r23,r23,0x7f74	                        #r23 = Party Data Pointer
                                               ori r22,r0,0x00ff	                        #r22 = FF
                                               andi r19,r4,0x00ff	                        #r19 = Unit's Gender
@GNC.restart_name_selection:                   jal @Random_Number                           #Random Number Generator
                                               ori r16,r0,0x0001	                        #r16 = 1 (success, for later)
                                               sll r3,r2,0x08		                        #Random * 256
                                               subu r2,r3,r2		                        #Random * 255 (supposed to be * 256 instead?)
                                               bgez r2, @GNC.1st_positive_result            #Branch if Random >= 0 (it's never negative)
                                               addu r6,r0,r0		                        #Counter = 0
                                               addiu r2,r2,0x7fff	                        #Random * 255 + 0x7FFF
@GNC.1st_positive_result:                      sra r2,r2,0x0f		                        #Random * 255 / 0x8000 (rand(0..254)
                                               addu r7,r20,r2		                        #Chosen Name = Name Mod + rand(0..254)
                                               andi r4,r7,0xffff                            #
                                               addu r5,r23,r0		                        #r5 = Party Data Pointer
@GNC.party_name_loop:                          lbu r2,0x0001(r5)	                        #Load Unit's Party ID
                                               nop                                          #
                                               beq r2,r22, @GNC.loop_prep                   #Branch if Party ID = FF
                                               nop                                          #
                                               lbu r2,0x0004(r5)	                        #Load Unit's Gender Byte
                                               nop                                          #
                                               andi r2,r2,0x00e0                            #
                                               bne r19,r2, @GNC.loop_prep                   #Branch if Unit's Gender != Unit's Party Gender
                                               nop                                          #
                                               lbu r2,0x00cf(r5)	                        #Load Unit's Name ID (high bit)
                                               lbu r3,0x00ce(r5)	                        #Load Unit's Name ID
                                               sll r2,r2,0x08		                        #High Bit * 256
                                               or r3,r3,r2			                        #Name ID + High Bit * 256
                                               bne r3,r4, @GNC.loop_prep_2                  #Branch if Name ID != Chosen Name
                                               addiu r6,r6,0x0001	                        #Counter ++
                                               j @GNC.escape_loop                           #
                                               addu r16,r0,r0		                        #r16 = 0 (Another Party Unit has this name)
@GNC.loop_prep:                                addiu r6,r6,0x0001	                        #Counter ++
@GNC.loop_prep_2:                              slti r2,r6,0x0014                            #
                                               bne r2,r0, @GNC.party_name_loop              #Branch if Counter < 20
                                               addiu r5,r5,0x0100	                        #Party Data Pointer += 0x100
@GNC.escape_loop:                              addu r6,r0,r0		                        #Counter = 0
                                               andi r5,r7,0xffff	                        #r5 = Unit's Chosen Name
                                               lui r3,0x8019                                #
                                               addiu r3,r3,0x08cc	                        #r3 = Unit Data Pointer
@GNC.choosen_name_loop:                        lbu r2,0x0006(r3)	                        #Load Unit's Gender
                                               nop                                          #
                                               andi r2,r2,0x00e0                            #
                                               bne r19,r2, @GNC.choosen_name_loop_prep      #Branch if Gender != Gender
                                               nop                                          #
                                               lhu r2,0x016c(r3)	                        #Load Unit's Name ID
                                               nop                                          #
                                               bne r2,r5, @GNC.choosen_name_loop_prep       #Branch if Name ID != Chosen Name
                                               nop                                          #
                                               j @GNC.party_already_has_name_check          #
                                               addu r16,r0,r0		                        #r16 = 0 (Another Battle Unit has this name)
@GNC.choosen_name_loop_prep:                   addiu r6,r6,0x0001	                        #Counter ++
                                               slti r2,r6,0x0015                            #
                                               bne r2,r0, @GNC.choosen_name_loop            #Branch if Counter < 21
                                               addiu r3,r3,0x01c0	                        #Pointer += 0x1c0
@GNC.party_already_has_name_check:             beq r16,r0, @GNC.restart_name_selection      #Branch if Another Unit has the chosen name
                                               nop                                          #
                                               sh r7,0x016c(r18)	                        #Store Unit's Chosen Name ID
@GNC.name_already_choosen:                     andi r4,r7,0x00ff	                        #r4 = Chosen Name
                                               jalr r21    			                        #Prep for Loading Text
                                               addu r4,r17,r4		                        #r4 = Chosen Name + Name Flags
                                               j @GNC.store_name                            #
                                               addu r4,r2,r0		                        #r4 = Text Pointer
@GNC.store_text_prep:                          jal @Get_Party_Data_Pointer                  #Get Party Data Pointer
                                               nop                                          #
                                               addiu r2,r2,0x00be	                        #Unit's Party Name Pointer
                                               addu r4,r2,r0		                        #r4 = "
@GNC.store_name:                               addiu r5,r18,0x012c	                        #r5 = Unit's Name Pointer
                                               jal @Store_X_into_Y                          #Store X into Y (Unit's Name)
                                               ori r6,r0,0x0010		                        #Limit = 16
                                               lbu r4,0x0003(r18)	                        #Load Unit's Job ID
                                               jalr r21 			                        #Prep for Loading Text
                                               ori r4,r4,0x3000		                        #Job ID + 0x3000 (Job Names)
                                               addu r4,r2,r0		                        #r4 = Text Pointer
                                               addiu r5,r18,0x013c	                        #r5 = Unit's Job Name Pointer
                                               jal @Store_X_into_Y                          #Store X into Y (Job Name)
                                               ori r6,r0,0x0010		                        #Limit = 16
                                               lbu r4,0x0012(r18)	                        #Load Unit's Primary Skillset
                                               jalr r21 			                        #Prep for Loading Text
                                               ori r4,r4,0x1000		                        #Primary Skillset ID += 0x1000 (Skillset Name)
                                               addu r4,r2,r0		                        #r4 = Text Pointer
                                               addiu r5,r18,0x014c	                        #r5 = Pointer to Unit's Primary Skillset Name
                                               jal @Store_X_into_Y                          #Store X into Y (Primary Skillset Name)
                                               ori r6,r0,0x0008		                        #Limit = 8
                                               lbu r4,0x0013(r18)	                        #Load Unit's Secondary Skillset ID
                                               jalr r21			                            #Prep for Loading Text
                                               ori r4,r4,0x1000		                        #Secondary Skillset ID += 0x1000 (skillset Name)
                                               addu r4,r2,r0		                        #r4 = Text Pointer
                                               addiu r5,r18,0x0154	                        #r5 = Pointer to Unit's Secondary Skillset Name
                                               jal @Store_X_into_Y                          #Store X into Y (Secondary Skillset Name)
                                               ori r6,r0,0x0008		                        #Limit = 8
                                               addiu r4,r18,0x01a7	                        #r4 = Pointer to Unit's Attack's Status Infliction
                                               jal 0x0005e644		                        #Data Nullifying (Attack's Status Infliction/Removal)
                                               ori r5,r0,0x000a		                        #Limit = 10
                                               lw r31,0x0130(r29)                           #
                                               lw r23,0x012c(r29)                           #
                                               lw r22,0x0128(r29)                           #
                                               lw r21,0x0124(r29)                           #
                                               lw r20,0x0120(r29)                           #
                                               lw r19,0x011c(r29)                           #
                                               lw r18,0x0118(r29)                           #
                                               lw r17,0x0114(r29)                           #
                                               lw r16,0x0110(r29)                           #
                                               addiu r29,r29,0x0138                         #
                                               jr r31                                       #
                                               nop											#
#/code

										@Calculate_Hightest_Party_Level:  #CHPL  #code
0x0005cbd0:                                    addiu r29,r29,0xffe0                         #
                                               sw r17,0x0014(r29)                           #
                                               addu r17,r0,r0		                        #High Level = 0
                                               sw r16,0x0010(r29)                           #
                                               addu r16,r0,r0		                        #Party ID = 0
                                               sw r18,0x0018(r29)                           #
                                               ori r18,r0,0x00ff	                        #r18 = FF
                                               sw r31,0x001c(r29)                           #
@CHPL.loop_start:                              jal @Get_Party_Data_Pointer                  #Get Party Data Pointer
                                               addu r4,r16,r0		                        #r4 = Party ID
                                               addu r3,r2,r0		                        #r3 = Party Data Pointer
                                               lbu r2,0x0001(r3)	                        #Load Party ID
                                               nop                                          #
                                               beq r2,r18, @CHPL.loop_prep	                #Branch if Unit doesn't exist
                                               addiu r16,r16,0x0001		                    #Party ID ++
                                               lbu r2,0x0016(r3)		                    #Load Party Level
                                               nop                                          #
                                               sltu r2,r17,r2                               #
                                               beq r2,r0, @CHPL.loop_check	                #Branch if High Level >= Level
                                               slti r2,r16,0x0014                           #
                                               lbu r17,0x0016(r3)		                    #High Level = Level
@CHPL.loop_prep:                               slti r2,r16,0x0014                           #
@CHPL.loop_check:                              bne r2,r0, @CHPL.loop_start		            #Branch if Party ID < 0x14
                                               sltiu r2,r17,0x0064                          #
                                               bne r2,r0, @CHPL.highest_level_found         #Branch if High Level < 100
                                               nop                                          #
                                               ori r17,r0,0x0063		                    #High Level = 99
@CHPL.highest_level_found:                     lui r1,0x8006                                #
                                               sb r17,0x6308(r1)		                    #Store Highest Party Level
                                               addu r2,r17,r0                               #r2 = High Level
                                               lw r31,0x001c(r29)                           #
                                               lw r18,0x0018(r29)                           #
                                               lw r17,0x0014(r29)                           #
                                               lw r16,0x0010(r29)                           #
                                               addiu r29,r29,0x0020                         #
                                               jr r31                                       #
                                               nop                                          #
#/code

										@Store_X_into_Y:  #SXIY  #code
0x0005cc64:                                    addiu r29,r29,0xfff8                         #
                                               blez r6, @SXIY.end                           #
                                               addu r3,r0,r0		                        #Counter = 0
@SXIY.loop_start:                              lbu r2,0x0000(r4)		                    #Load X
                                               addiu r4,r4,0x0001		                    #X Pointer += 1
                                               addiu r3,r3,0x0001		                    #Counter += 1
                                               sb r2,0x0000(r5)		                        #Store X into Y
                                               slt r2,r3,r6                                 #
                                               bne r2,r0, @SXIY.loop_start		            #Branch if not finished
                                               addiu r5,r5,0x0001		                    #Y Pointer += 1
@SXIY.end:                                     addiu r29,r29,0x0008                         #
                                               jr r31                                       #
                                               nop								            #
#/code
											   
										@Calculate_Random_Equipment:  #CRE  #code                         
0x0005cc98:                                    addiu r29,r29,0xff68                         #
                                               addu r13,r4,r0		                        #r13 = Unit's Data Pointer
                                               andi r5,r5,0x00ff	                        #r5 = Item Type
                                               ori r2,r0,0x0020                             #
                                               sw r31,0x0094(r29)                           #
                                               beq r5,r2, @CRE.head_id_floor                #Branch if Item Type = Headgear
                                               sw r16,0x0090(r29)                           #
                                               slti r2,r5,0x0021                            #
                                               beq r2,r0, @CRE.arm_id_floor                 #Branch if Item Type >= 0x21
                                               ori r2,r0,0x0008                             #
                                               beq r5,r2, @CRE.accessory_id_floor           #Branch if Item Type = Accessories
                                               ori r2,r0,0x0010                             #
                                               beq r5,r2, @CRE.armor_id_floor               #Branch if Item Type = Armor
                                               ori r2,r0,0x00ac		                        #Item Counter = 0xac
                                               j @CRE.start                                 #
                                               addu r2,r0,r0		                        #Item Counter = 0
@CRE.arm_id_floor:                             ori r2,r0,0x0040                             #
                                               beq r5,r2, @CRE.shield_id_floor              #Branch if Item Type = Shields
                                               ori r2,r0,0x0080		                        #Item Counter = 0x80 (also used for check)
                                               bne r5,r2, @CRE.start                        #Branch if Item Type = Weapons
                                               addu r2,r0,r0		                        #Item Counter = 0
                                               ori r2,r0,0x0001		                        #Item Counter = 1
                                               j @CRE.start2                                #
                                               ori r10,r0,0x0080	                        #Limit = 0x80 (Item Type = Weapons)
@CRE.shield_id_floor:                          j @CRE.start2                                #
                                               ori r10,r0,0x0090	                        #Limit = 0x90 (Item Type = Shields)
@CRE.head_id_floor:                            ori r2,r0,0x0090		                        #Item Counter = 0x90
                                               j @CRE.start2                                #
                                               ori r10,r0,0x00ac	                        #Limit = 0xac (Item Type = Armor)
@CRE.armor_id_floor:                           j @CRE.start2                                #
                                               ori r10,r0,0x00d0	                        #Limit = 0xd0 (Item Type = Headgear)
@CRE.accessory_id_floor:                       ori r2,r0,0x00d0		                        #Item Counter = 0xd0
                                               j @CRE.start2                                #
                                               ori r10,r0,0x00f0	                        #Limit = 0xf0 (Item Type = Accessories)
@CRE.start:                                    ori r10,r0,0x0100	                        #Limit = 0x100 (Item Type != Any above)
@CRE.start2:                                   addu r9,r0,r0		                        #Temp Counter = 0
                                               addu r8,r2,r0		                        #r8 = Item Counter
                                               lbu r14,0x0022(r13)	                        #Load Unit's Level
                                               slt r2,r8,r10                                #
                                               beq r2,r0, @CRE.check_next_item              #Branch if Item Counter = 0
                                               addu r12,r0,r0		                        #High Level = 0
                                               andi r7,r7,0x00ff	                        #r7 = Chosen Type
                                               sll r2,r8,0x01		                        #Item Counter * 2
                                               addu r2,r2,r8		                        #IC * 3
                                               sll r11,r2,0x02		                        #Pointer Mod = IC * 12
@CRE.main_loop_start:                          lui r2,0x8006                                #
                                               addiu r2,r2,0x2eb8                           #
                                               addu r5,r11,r2                               #
                                               lbu r3,0x0003(r5)	                        #Load Item's Type Flags
                                               nop                                          #
                                               andi r2,r3,0x0002                            #
                                               bne r2,r0, @CRE.main_loop_prep               #Branch if Item is Rare
                                               ori r2,r0,0x00ff		                        #r2 = FF
                                               lbu r3,0x0005(r5)	                        #Load Item's Type
                                               beq r7,r2, @CRE.equipable?                   #Branch if Chosen Type = Any
                                               nop                                          #
                                               bne r3,r7, @CRE.main_loop_prep               #Branch if Chosen Type != Item Type
                                               nop                                          #
@CRE.equipable?:                               andi r3,r3,0x00ff                            #
                                               srl r2,r3,0x03		                        #Type / 8
                                               addu r2,r13,r2                               #
                                               lbu r4,0x004a(r2)	                        #Load Unit's Equippable Item Flags
                                               andi r3,r3,0x0007                            #
                                               ori r2,r0,0x0080		                        #r2 = 0x80
                                               srav r2,r2,r3		                        #0x80 / 2^(Type AND 7) (flag to check)
                                               and r4,r4,r2                                 #
                                               beq r4,r0, @CRE.main_loop_prep               #Branch if Type isn't usable
                                               andi r2,r6,0x00ff	                        #r2 = Required Flags
                                               beq r2,r0, @CRE.required_lvl                 #Branch if there are no Required Flags
                                               nop                                          #
                                               lbu r2,0x0004(r5)	                        #Load Item's Second Table ID
                                               nop                                          #
                                               sll r2,r2,0x03		                        #ID * 8
                                               lui r1,0x8006                                #
                                               addu r1,r1,r2                                #
                                               lbu r2,0x3ab9(r1)	                        #Load Item's Attack Flags
                                               nop                                          #
                                               and r2,r6,r2                                 #
                                               beq r2,r0, @CRE.main_loop_prep               #Branch if Required Flags aren't present
                                               nop                                          #
@CRE.required_lvl:                             lbu r3,0x0002(r5)	                        #Load Item's Required Level
                                               nop                                          #
                                               andi r4,r3,0x00ff                            #
                                               sltu r2,r14,r4                               #
                                               bne r2,r0, @CRE.main_loop_prep               #Branch if Unit's Level is too low
                                               sltu r2,r12,r4                               #
                                               beq r2,r0, @CRE.skip	                        #Branch if High Level >= Required Level
                                               nop				                            #(a new high level overrides the old possible equipment list)
                                               addu r12,r3,r0		                        #High Level = Required Level
                                               addu r9,r0,r0		                        #Temp Counter = 0
@CRE.skip:                                     addu r3,r9,r0		                        #r3 = Current Temp Counter
                                               addiu r9,r9,0x0001	                        #Temp Counter ++
                                               andi r3,r3,0x00ff                            #
                                               addiu r2,r29,0x0010	                        #r2 = Stack Pointer + 0x10
                                               addu r2,r2,r3                                #
                                               sb r8,0x0000(r2)		                        #Store Item Counter
@CRE.main_loop_prep:                           addiu r8,r8,0x0001	                        #Item Counter ++
                                               slt r2,r8,r10                                #
                                               bne r2,r0, @CRE.main_loop_start              #Branch if Item Counter < Limit
                                               addiu r11,r11,0x000c	                        #Pointer Mod += 0xc
@CRE.check_next_item:                          andi r16,r9,0x00ff	                        #r16 = Stack Counter
                                               beq r16,r0, @CRE.end                         #Branch if nothing was stored
                                               ori r2,r0,0x00fe		                        #Item ID = FE
                                               jal @Random_Number		                    #Random Number Generator
                                               nop                                          #
                                               mult r2,r16			                        #Random * Stack Counter
                                               mflo r2			                            #r2 = "
                                               bgez r2, @CRE.return_choosen_item_id         #Branch if Random is Positive
                                               srl r3,r2,0x0f		                        #rand(0..Stack Counter - 1)
                                               addiu r2,r2,0x7fff                           #
                                               srl r3,r2,0x0f                               #
@CRE.return_choosen_item_id:                   andi r2,r3,0x00ff                            #
                                               addu r2,r29,r2                               #
                                               lbu r2,0x0010(r2)	                        #Load Chosen Item ID
@CRE.end:                                      lw r31,0x0094(r29)                           #
                                               lw r16,0x0090(r29)                           #
                                               addiu r29,r29,0x0098                         #
                                               jr r31                                       #
                                               nop                                          #
#/code

										@Calculate_Learned_Abilities:  #CLA  #code                                                             #
0x0005ce74:                                    addiu r29,r29,0xffd0                         #
                                               addu r8,r4,r0		                        #r8 = Unit's Data Pointer
                                               addu r7,r5,r0		                        #Job ID = Job Counter + 0x4a/0x4b
                                               sw r22,0x0028(r29)                           #
                                               addu r22,r0,r0		                        #r22 = 0 (Can Learn)
                                               addiu r9,r7,0xffb6	                        #Job Counter = Job Counter - 0x4a
                                               ori r2,r0,0x004a	                        	#r2 = 0x4a
                                               sw r31,0x002c(r29)                           #
                                               sw r21,0x0024(r29)                           #
                                               sw r20,0x0020(r29)                           #
                                               sw r19,0x001c(r29)                           #
                                               sw r18,0x0018(r29)                           #
                                               sw r17,0x0014(r29)                           #
                                               bne r7,r2, @CLA.squire_skip                  #Branch if Job ID != Base Job
                                               sw r16,0x0010(r29)                           #
                                               lbu r3,0x0000(r8)		                    #Load Unit's Sprite Set
                                               nop                                          #
                                               addiu r2,r3,0xff80		                    #Sprite Set - 0x80 (no special jobs)
                                               andi r2,r2,0x00ff                            #
                                               sltiu r2,r2,0x0002                           #
                                               bne r2,r0, @CLA.dance_bard_check             #Branch if Unit is a generic Male/Female
                                               andi r3,r3,0x00ff                            #
                                               ori r2,r0,0x0082                             #
                                               bne r3,r2, @CLA.special_unit                 #Branch if Unit isn't a Monster
                                               nop                                          #
                                               lbu r7,0x0003(r8)		                    #Load Unit's Job ID
                                               j @CLA.dance_bard_check                      #
                                               nop                                          #
@CLA.special_unit:                             lbu r7,0x0000(r8)		                    #Load Unit's Sprite Set
                                               j @CLA.dance_bard_check                      #
                                               nop                                          #
@CLA.squire_skip:                              lui r2,0x0080		                        #Counter = 0x800000
                                               srav r16,r2,r9		                        #Counter >> Job Counter
                                               lbu r2,0x0096(r8)		                    #Load Unit's Unlocked Jobs 1-8
                                               lbu r3,0x0097(r8)		                    #Load Unit's Unlocked Jobs 9-16
                                               lbu r4,0x0098(r8)		                    #Load Unit's Unlocked Jobs 17-20
                                               sll r2,r2,0x10                               #
                                               sll r3,r3,0x08                               #
                                               addu r2,r2,r3                                #
                                               addu r5,r2,r4		                        #r5 = Complete Unlocked Jobs
                                               and r2,r5,r16                                #
                                               beq r2,r0, @CLA.end		                    #Branch if Job isn't unlocked
                                               nop                                          #
@CLA.dance_bard_check:                         lbu r3,0x0006(r8)		                    #Load Unit's Gender Byte
                                               ori r2,r0,0x005b                             #r2 = 5b
@CLA.bard_check:                               bne r7,r2, @CLA.dancer_check                 #Branch if Job ID != 0x5b (Bard)
                                               ori r2,r0,0x005c                             #r2 = 5c
                                               andi r2,r3,0x0040                            #
                                               bne r2,r0, @CLA.end		                    #Branch if Unit is Female
                                               ori r2,r0,0x005c                             #r2 = 5c
@CLA.dancer_check:                             bne r7,r2, @load_job_id                      #Branch if Job ID != 0x5c (Dancer)
                                               andi r2,r3,0x0080                            #
                                               bne r2,r0, @CLA.end		                    #Branch if Unit is Male
                                               nop                                          #
@load_job_id:                                  lbu r2,0x0003(r8)		                    #Load Unit's Job ID
                                               nop                                          #
                                               bne r7,r2, @CLA.find_job_data_pointer        #Branch if Current Job ID != Unit's Job ID
                                               sll r2,r7,0x01                               #ID * 2
                                               lbu r2,0x001d(r6)		                    #Load ENTD Primary Skillset
                                               lbu r21,0x0012(r8)		                    #Load Unit's Primary Skillset
                                               bne r2,r0, @find_known_abilities             #Branch if ENTD Primary Skillset != 0
                                               addu r16,r0,r0                               #Counter = 0
                                               j @find_known_abilities                      #
                                               ori r22,r0,0x0001                            #r22 = 1 (Can't Learn Normally)
@CLA.find_job_data_pointer:                    addu r2,r2,r7		                        #ID * 3
                                               lui r3,0x8006                                #
                                               lw r3,0x6194(r3)		                        #Load Job Data Pointer
                                               sll r2,r2,0x04		                        #ID * 48
                                               addu r2,r2,r3                                #
                                               lbu r21,0x0000(r2)                           #Load Job's Skillset
                                               addu r16,r0,r0		                        #Counter = 0
@find_known_abilities:                         sll r2,r9,0x01		                        #Job Counter * 2
                                               addu r19,r2,r8		                        #r19 = Unit's Data Pointer + Job Counter * 2
                                               addu r2,r2,r9		                        #Job Counter * 3
                                               addu r2,r2,r8		                        #r2 = Unit's Data Pointer + Job Counter * 3
                                               addiu r20,r2,0x0099                          #r20 = Unit's Known Abilities Pointer
                                               addu r18,r0,r0		                        #r18 = 0 (No Ability Learned)
@CLA.ability_loop:                             addu r4,r21,r0		                        #r4 = Job's Skillset
                                               jal @Load_Ability_From_Skillset              #Load Ability From Skillset
                                               addu r5,r16,r0		                        #r5 = Counter
                                               andi r2,r2,0xffff                            #
                                               beq r2,r0, @CLA.prep_loop                    #Branch if Ability ID = 0
                                               sll r3,r2,0x03		                        #ID * 8
                                               lui r2,0x8006                                #
                                               addiu r2,r2,0xebf0                           #r2 = Ability Data 1 Pointer
                                               addu r17,r3,r2                               #
                                               lbu r5,0x0002(r17)                           #Load Ability's Chance to Learn
                                               beq r22,r0, @CLA.learn_ability_roll          #Branch if Unit Can Learn abilities
                                               nop                                          #
                                               j @CLA.ability_learned_check                 #
                                               ori r18,r0,0x0001		                    #r18 = 1 (Ability Learned)
@CLA.learn_ability_roll:                       jal 0x0005e0cc                               #Check if Random >= Chance
                                               ori r4,r0,0x0064                             #Hit% = 100
                                               bne r2,r0, @CLA.ability_learned_check        #Branch if Ability wasn't learned
                                               nop                                          #
                                               lhu r3,0x0000(r17)		                    #Load Ability's JP Cost
                                               lhu r2,0x00dc(r19)		                    #Load Unit's Current JP
                                               nop                                          #
                                               sltu r2,r2,r3                                #
                                               bne r2,r0, @CLA.ability_learned_check        #Branch if JP < JP Cost
                                               addu r4,r16,r0                               #r4 = Counter
                                               lhu r2,0x00dc(r19)		                    #Load Unit's Current JP
                                               nop                                          #
                                               subu r2,r2,r3                                #JP - JP Cost
                                               bgez r16, @CLA.worthless_code_start          #Branch if Counter >= 0
                                               sh r2,0x00dc(r19)		                    #Store Unit's new Current JP
                                               addiu r4,r16,0x0007                          #
@CLA.worthless_code_start:                     ori r18,r0,0x0001		                    #r18 = 1 (Ability Learned)
                                               sra r4,r4,0x03		                        #Counter / 8 *Starting here is code that can be deleted, plus above Counter check/addition*
                                               addu r5,r20,r4		                        #Known Abilities Pointer + Counter / 8 (byte to grab)
                                               sll r4,r4,0x03		                        #Counter / 8 * 8
                                               subu r4,r16,r4		                        #Counter - Counter / 8 * 8 (current Ability)
                                               ori r2,r0,0x0080		                        #r2 = 0x80
                                               lbu r3,0x0000(r5)                            #Load Unit's Known Abilities
                                               srav r2,r2,r4		                        #0x80 / 2^(current Ability Counter)
                                               or r3,r3,r2			                        #Enable Ability
                                               sb r3,0x0000(r5)		                        #Store unit's new Known Abilities *End*
@CLA.ability_learned_check:                    beq r18,r0, @CLA.prep_loop                   #Branch if an Ability wasn't learned
                                               nop				                            #(copy-paste code)
                                               bgez r16, @CLA.positive_result               #Branch if Counter is positive
                                               addu r4,r16,r0		                        #r4 = Counter
                                               addiu r4,r16,0x0007                          #
@CLA.positive_result:                          sra r4,r4,0x03		                        #Counter / 8
                                               addu r5,r20,r4		                        #Known Abilities Pointer + Counter / 8
                                               sll r4,r4,0x03		                        #Counter / 8 * 8
                                               subu r4,r16,r4		                        #Counter - Counter / 8 * 8
                                               ori r2,r0,0x0080		                        #r2 = 0x80
                                               lbu r3,0x0000(r5)                            #Load Unit's Known Abilities
                                               srav r2,r2,r4		                        #0x80 / 2^(current Ability Counter)
                                               or r3,r3,r2			                        #Enable Ability
                                               sb r3,0x0000(r5)		                        #Store Unit's new Known Abilities
@CLA.prep_loop:                                addiu r16,r16,0x0001	                        #Counter ++
                                               slti r2,r16,0x0018                           #
                                               bne r2,r0, @CLA.ability_loop                 #Branch if Counter < 0x18
                                               addu r18,r0,r0		                        #
@CLA.end:                                      lw r31,0x002c(r29)                           #
                                               lw r22,0x0028(r29)                           #
                                               lw r21,0x0024(r29)                           #
                                               lw r20,0x0020(r29)                           #
                                               lw r19,0x001c(r29)                           #
                                               lw r18,0x0018(r29)                           #
                                               lw r17,0x0014(r29)                           #
                                               lw r16,0x0010(r29)                           #
                                               addiu r29,r29,0x0030                         #
                                               jr r31                                       #
                                               nop                                          #
#/code
											   
										@Calculate_Unit_RSM:  #CURSM  #code
0x0005d0bc:                                    addiu r29,r29,0xfbe0                         #
                                               addu r8,r4,r0		                        #r8 = Unit's Data Pointer
                                               sw r22,0x0410(r29)                           #
                                               addu r22,r6,r0		                        #r22 = R/S/M Check
                                               addu r10,r7,r0		                        #r10 = ENTD Pointer
                                               andi r5,r5,0xffff	                        #r5 = Ability ID
                                               sltiu r2,r5,0x01fe	                        #(could load all of the known R/S/M into the stack, which
                                               sw r31,0x041c(r29)	                        #it gives plenty of space for (~0x400, and if all 20 jobs
                                               sw r30,0x0418(r29)	                        #had 6 R/S/M each, that'd only be 0xf0 total), and sort
                                               sw r23,0x0414(r29)	                        #them based on type, then randomly choose all 3 at once)
                                               sw r21,0x040c(r29)                           #
                                               sw r20,0x0408(r29)                           #
                                               sw r19,0x0404(r29)                           #
                                               sw r18,0x0400(r29)                           #
                                               sw r17,0x03fc(r29)                           #
                                               beq r2,r0, @CURSM.random_ability             #Branch if Ability is Random
                                               sw r16,0x03f8(r29)                           #
                                               j @CURSM.end                                 #
                                               addu r2,r5,r0		                        #Ability ID = ENTD Ability
@CURSM.random_ability:                         lbu r2,0x0006(r8)	                        #Load Unit's Gender Byte
                                               nop                                          #
                                               andi r2,r2,0x0020                            #
                                               bne r2,r0, @CURSM.end                        #Branch if Unit is a monster
                                               addu r2,r0,r0		                        #Ability ID = 0
                                               addu r19,r0,r0		                        #Counter = 0
                                               addu r4,r8,r0		                        #r4 = Unit's Data Pointer
                                               addiu r3,r29,0x0010	                        #r3 = Stack Pointer + 0x10
@CURSM.innate_loop:                            lhu r2,0x000a(r4)	                        #Load Unit's Innate Ability
                                               addiu r4,r4,0x0002	                        #Unit's Data Pointer += 2
                                               addiu r19,r19,0x0001	                        #Counter ++
                                               sh r2,0x03c0(r3)		                        #Store Innate Ability on the Stack
                                               slti r2,r19,0x0004                           #
                                               bne r2,r0, @CURSM.innate_loop                #Branch if Counter < 4
                                               addiu r3,r3,0x0002	                        #Stack Pointer += 2
                                               addu r20,r0,r0		                        #Stack Counter = 0
                                               ori r7,r0,0x0001		                        #r7 = 1 (Secondary not checked yet)
                                               lbu r6,0x0013(r8)	                        #Load Unit's Secondary ID
                                               addu r19,r0,r0		                        #Counter = 0
                                               addu r30,r8,r0		                        #r30 = Unit's Data Pointer
@CURSM.main_loop:                              addu r18,r0,r0		                        #Skillset = 0
                                               ori r2,r0,0x0013		                        #r2 = 0x13
                                               bne r19,r2, @CURSM.squire_check              #Branch if Counter != 0x13 (Mime check)
                                               ori r21,r0,0x0001	                        #r21 = 1 (Checking known abilities)
                                               beq r7,r0, @CURSM.escape_loop                #Branch if Secondary has been checked
                                               nop                                          #
                                               addu r18,r6,r0		                        #Skillset = Unit's Secondary ID
                                               beq r18,r0, @CURSM.escape_loop               #Branch if Unit doesn't have a secondary
                                               nop                                          #
                                               j @CURSM.load_skilset                        #(this is for mime with a non-generic secondary?)
                                               addu r21,r0,r0		                        #r21 = 0 (Not checking known abilities)
@CURSM.squire_check:                           bne r19,r0, @CURSM.load_skilset              #Branch if Counter != 0 (Base ID check)
                                               addiu r9,r19,0x004a	                        #Job ID = Counter + 0x4a
                                               lbu r3,0x0000(r8)	                        #Load Unit's Sprite Set
                                               nop                                          #
                                               addiu r2,r3,0xff80	                        #Sprite Set - 0x80
                                               andi r2,r2,0x00ff                            #
                                               sltiu r2,r2,0x0002                           #
                                               bne r2,r0, @CURSM.load_primary_skillset      #Branch if Sprite Set is Generic Male/Female
                                               nop                                          #
                                               addu r9,r3,r0		                        #Job ID = Sprite Set
@CURSM.load_primary_skillset:                  lbu r3,0x001d(r10)	                        #Load ENTD Primary Skillset
                                               nop                                          #
                                               beq r3,r0, @CURSM.load_skilset               #Branch if Primary Skillset = 0
                                               ori r2,r0,0x00ff                             #
                                               beq r3,r2, @CURSM.load_skilset               #Branch if Primary Skillset = FF (job's)
                                               nop                                          #
                                               lbu r18,0x001d(r10)	                        #Load ENTD Primary Skillset
@CURSM.load_skilset:                           nop                                          #
                                               bne r18,r0, @CURSM.skip2                     #Branch if Skillset != 0
                                               andi r3,r9,0x00ff	                        #r3 = Job ID
                                               beq r3,r0, @CURSM.escape_loop                #Branch if Job ID = 0
                                               sll r2,r3,0x01		                        #Job ID * 2
                                               addu r2,r2,r3		                        #ID * 3
                                               lui r3,0x8006                                #
                                               lw r3,0x6194(r3)		                        #Load Job Data Pointer
                                               sll r2,r2,0x04		                        #ID * 48
                                               addu r2,r2,r3                                #
                                               lbu r18,0x0000(r2)	                        #Load Job's Skillset
@CURSM.skip2:                                  nop                                          #
                                               bne r18,r6, @CURSM.skip_clear_secondary      #Branch if Skillset != Unit's Secondary ID
                                               nop                                          #
                                               addu r7,r0,r0		                        #r7 = 0 (Secondary checked)
@CURSM.skip_clear_secondary:                   beq r21,r0, @CURSM.1st2nd_mime_skip          #Branch if not checking known Abilities (Mime)
                                               ori r16,r0,0x0010	                        #Known Ability Counter = 0x10 (R/S/M)
                                               lbu r11,0x009b(r30)	                        #Load Unit's Known R/S/M
                                               nop                                          #
                                               sb r11,0x03d8(r29)	                        #Temp Store Known R/S/M
@CURSM.1st2nd_mime_skip:                       lbu r23,0x03d8(r29)	                        #r23 = Known R/S/M
@CURSM.inner_loop:                             beq r21,r0, @CURSM.mime_skip                 #Branch if not checking known abilities (Mime)
                                               addu r17,r0,r0		                        #r17 = 0 (ID isn't acceptable)
                                               bgez r16,0x0005d230	                        #Branch if Ability Counter >= 0
                                               addu r3,r16,r0		                        #r3 = Ability Counter
                                               addiu r3,r16,0x0007                          #
                                               sra r3,r3,0x03		                        #Ability Counter / 8
                                               sll r3,r3,0x03		                        #Ability Counter / 8 * 8
                                               subu r3,r16,r3		                        #Current Ability = Ability Counter - Ability Counter / 8 * 8
                                               ori r2,r0,0x0080		                        #r2 = 0x80
                                               srav r2,r2,r3		                        #0x80 / 2^(Current Ability)
                                               and r2,r23,r2		                        #r2 = Current Known R/S/M
                                               beq r2,r0, @CURSM.loop_prep                  #Branch if R/S/M isnt known
                                               addu r17,r0,r0		                        #r17 = 0 (ID isn't acceptable)
@CURSM.mime_skip:                              andi r4,r18,0x00ff	                        #r4 = Skillset
                                               addu r5,r16,r0		                        #r5 = Known Ability Counter
                                               sw r6,0x03e0(r29)	                        #Temp Store Unit's Secondary Skillset
                                               sw r7,0x03e4(r29)	                        #Temp Store r7
                                               sw r8,0x03e8(r29)	                        #Temp Store Unit's Data Pointer
                                               sw r9,0x03ec(r29)	                        #Temp Store Job ID
                                               jal @Load_Ability_From_Skillset              #Load Ability From Skillset
                                               sw r10,0x03f0(r29)	                        #Temp Store ENTD Pointer
                                               addu r4,r2,r0		                        #r4 = R/S/M ID
                                               andi r3,r4,0xffff                            #
                                               ori r2,r0,0x01a9		                        #r2 = 0x1a9 (Sunken State)
                                               lw r6,0x03e0(r29)                            #
                                               lw r7,0x03e4(r29)                            #
                                               lw r8,0x03e8(r29)                            #
                                               lw r9,0x03ec(r29)                            #
                                               lw r10,0x03f0(r29)	                        #Reload Temp Stored Values
                                               beq r3,r2, @CURSM.loop_prep                  #Branch if R/S/M ID = Sunken State
                                               nop                                          #
                                               lhu r2,0x03d0(r29)	                        #Load Innate Ability 1
                                               nop                                          #
                                               beq r3,r2, @CURSM.loop_prep                  #Branch if Innate = Sunken State
                                               nop                                          #
                                               lhu r2,0x03d2(r29)	                        #Load Innate Ability 2
                                               nop                                          #
                                               beq r3,r2, @CURSM.loop_prep                  #Branch if Innate = Sunken State
                                               nop                                          #
                                               lhu r2,0x03d4(r29)	                        #Load Innate Ability 3
                                               nop                                          #
                                               beq r3,r2, @CURSM.loop_prep                  #Branch if Innate = Sunken State
                                               nop                                          #
                                               lhu r2,0x03d6(r29)	                        #Load Innate Ability 4
                                               nop                                          #
                                               beq r3,r2, @CURSM.loop_prep                  #Branch if Innate = Sunken State
                                               andi r2,r22,0x0002                           #
                                               beq r2,r0, @CURSM.support_id_check           #Branch if not setting reaction
                                               addiu r2,r4,0xfe5a	                        #r2 = R/S/M - 0x1a6
                                               andi r2,r2,0xffff                            #
                                               sltiu r17,r2,0x0020	                        #r17 = Reaction is a Reaction ID Check (ID acceptable check)
@CURSM.support_id_check:                       andi r2,r22,0x0004                           #
                                               beq r2,r0, @CURSM.movement_id_check          #Branch if not setting Support
                                               addiu r2,r4,0xfe3a	                        #r2 = R/S/M - 0x1c6
                                               andi r2,r2,0xffff                            #
                                               sltiu r2,r2,0x0020                           #
                                               beq r2,r0, @CURSM.2nd_movement_id_check      #Branch if Support isn't a support ID
                                               andi r2,r22,0x0008                           #
                                               ori r17,r0,0x0001	                        #r17 = 1 (ID is acceptable)
@CURSM.movement_id_check:                      andi r2,r22,0x0008                           #
@CURSM.2nd_movement_id_check:                  beq r2,r0, @CURSM.main_loop_check            #Branch if not setting movement
                                               andi r2,r4,0xffff                            #
                                               sltiu r2,r2,0x01e6                           #
                                               bne r2,r0, @CURSM.main_loop_check            #Branch if Movement isn't a Movement ID
                                               nop                                          #
                                               ori r17,r0,0x0001	                        #r17 = 1 (ID is acceptable)
@CURSM.main_loop_check:                        beq r17,r0, @CURSM.loop_prep                 #Branch if ID isn't acceptable
                                               sll r2,r20,0x01		                        #Stack Counter * 2
                                               addiu r3,r29,0x0010	                        #r3 = Stack Pointer + 0x10
                                               addu r2,r2,r3                                #
                                               sh r4,0x0000(r2)		                        #Store R/S/M ID
                                               addiu r20,r20,0x0001	                        #Stack Counter ++
@CURSM.loop_prep:                              addiu r16,r16,0x0001	                        #Ability Counter ++
                                               slti r2,r16,0x0016                           #
                                               bne r2,r0, @CURSM.inner_loop                 #Branch if Ability Counter < 0x16
                                               nop                                          #
@CURSM.escape_loop:                            addiu r19,r19,0x0001	                        #Counter ++
                                               slti r2,r19,0x0014	                        #(could limit to 0x13 to skip mime)
                                               bne r2,r0, @CURSM.main_loop                  #Branch if Counter < 0x14
                                               addiu r30,r30,0x0003	                        #Unit's Known Abilities Pointer += 3
                                               beq r20,r0, @CURSM.end                       #Branch if Stack Counter = 0
                                               addu r2,r0,r0		                        #r2 = 0
                                               jal @Random_Number                           #Random Number Generator
                                               nop                                          #
                                               mult r2,r20			                        #Random * Stack Counter
                                               mflo r2                                      # 
                                               bgez r2, @CURSM.positive_result              #Branch if Random * Stack Counter is positive
                                               nop                                          #
                                               addiu r2,r2,0x7fff                           #
@CURSM.positive_result:                        sra r2,r2,0x0f		                        #rand(0..Stack Counter)
                                               sll r2,r2,0x01		                        #rand(0..Stack Counter) * 2
                                               addu r2,r29,r2                               #
                                               lhu r2,0x0010(r2)	                        #Load chosen R/S/M
@CURSM.end:                                    lw r31,0x041c(r29)                           #
                                               lw r30,0x0418(r29)                           #
                                               lw r23,0x0414(r29)                           #
                                               lw r22,0x0410(r29)                           #
                                               lw r21,0x040c(r29)                           #
                                               lw r20,0x0408(r29)                           #
                                               lw r19,0x0404(r29)                           #
                                               lw r18,0x0400(r29)                           #
                                               lw r17,0x03fc(r29)                           #
                                               lw r16,0x03f8(r29)                           #
                                               addiu r29,r29,0x0420                         #
                                               jr r31                                       #
                                               nop                                          #
#/code

										@Find_Skillset_Job_ID:  #FSJI  #Unused Routine  #code
0x0005d3c4:                                    addu r5,r0,r0		                        #Job ID = 0
                                               lui r6,0x8006                                #
                                               lw r6,0x6194(r6)		                        #Load Job Data Pointer
                                               andi r4,r4,0x00ff	                        #r4 = Chosen Skillset
                                               andi r3,r5,0x00ff	                        #r5 = Job ID
@FSJI.loop:                                    sll r2,r3,0x01		                        #ID * 2
                                               addu r2,r2,r3		                        #ID * 3
                                               sll r2,r2,0x04		                        #ID * 48
                                               addu r2,r2,r6                                #
                                               lbu r2,0x0000(r2)	                        #Load Job's Skillset
                                               nop                                          #
                                               beq r2,r4, @FSJI.end	                        #Branch if Skillset = Chosen Skillset
                                               addu r2,r3,r0		                        #r2 = Job ID
                                               addiu r5,r5,0x0001	                        #Job ID ++
                                               andi r2,r5,0x00ff                            #
                                               sltiu r2,r2,0x009f                           #
                                               bne r2,r0, @FSJI.loop                        #Branch if Job ID < 0x9f
                                               andi r3,r5,0x00ff	                        #r3 = Job ID
@FSJI.end:                                     jr r31                                       #
                                               nop					                        #
#/code

										@Status_Initialization:  #SI  #code                                                                       #
0x0005d414:                                    addiu r29,r29,0xffe8                         #
                                               sw r16,0x0010(r29)                           #
                                               addu r16,r4,r0		                        #r16 = Unit's Data Pointer
                                               addu r5,r0,r0		                        #Counter = 0
                                               sw r31,0x0014(r29)                           #
@SI.loop:                                      addu r4,r16,r5		                        #Pointer += Counter
                                               addiu r5,r5,0x0001	                        #Counter ++
                                               lbu r2,0x004e(r4)	                        #Load Unit's Innate Statuses
                                               lbu r3,0x0058(r4)	                        #Load Unit's Current Statuses
                                               nor r2,r0,r2		                     	    #(innate added to inflicted later)
                                               and r3,r3,r2		                     	    #Remove Unit's Innate Statuses from Current Statuses
                                               slti r2,r5,0x0005                            #
                                               bne r2,r0, @SI.loop		                    #Branch if Counter < 5
                                               sb r3,0x01bb(r4)	                     	    #Store new Inflicted Statuses (current that aren't innate)
                                               jal @Null_CT_Initialize_Death_Counter        #Nullify CT/Initialize Death Counter
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               jal @Status_CT_Setting                       #Float/Current Statuses/Status Immunities/Status CT
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               lw r31,0x0014(r29)                           #
                                               lw r16,0x0010(r29)                           #
                                               addiu r29,r29,0x0018                         #
                                               jr r31                                       #
                                               nop                                          #
#/code

										@Null_CT_Initialize_Death_Counter:  #NCTDC  #code
0x0005d470:                                    addiu r29,r29,0xffe8                         #
                                               sw r16,0x0010(r29)                           #
                                               addu r16,r4,r0		                        #r16 = Unit's Data Pointer
                                               addiu r4,r16,0x005d	  	                    # r4 = Pointer to Unit's Poison CT
                                               sw r31,0x0014(r29)                           #
                                               jal 0x0005e644		                        #Data Nullifying (Status CT)
                                               ori r5,r0,0x0010		                        #Limit = 0x10
                                               lbu r2,0x0005(r16)	  	                    # Load Unit's ENTD Flags
                                               nop                                          #
                                               andi r2,r2,0x0004                            #
                                               bne r2,r0, @NCTDC.end  	                    #Branch if Unit is Immortal
                                               ori r2,r0,0x00ff		                        #r2 = FF
                                               lbu r2,0x0006(r16)	  	                    #Load Unit's Gender Byte
                                               nop                                          #
                                               andi r2,r2,0x0009                            #
                                               bne r2,r0, @NCTDC.end  	                    #Branch if Unit has Load/Save Formation
                                               ori r2,r0,0x00ff		                        #r2 = FF
                                               ori r2,r0,0x0003		                        #r2 = 3
@NCTDC.end:                                    sb r2,0x0007(r16)	  	                    #Store Death Counter = 3/FF
                                               lw r31,0x0014(r29)                           #
                                               lw r16,0x0010(r29)                           #
                                               addiu r29,r29,0x0018                         #
                                               jr r31                                       #
                                               nop                                          #
#/code

										@Status_CT_Setting:  #SCS  #0x0005d4d0 #code
                                               addiu r29,r29,0xffe0                         #
                                               sw r17,0x0014(r29)                           #
                                               addu r17,r4,r0		                        # r17 = Unit's Data Pointer
                                               sw r31,0x001c(r29)                           #
                                               sw r18,0x0018(r29)                           #
                                               sw r16,0x0010(r29)                           #
                                               lbu r2,0x0095(r17)	                        #Load Unit's 3rd set of movements
                                               nop                                          #
                                               andi r2,r2,0x0008                            #
                                               beq r2,r0, @SCS.unit_innate_loop             #Branch if Unit doesn't have Float
                                               addu r16,r0,r0		                        #Counter = 0
                                               lbu r2,0x0050(r17)	                        #Load Unit's Innate Statuses
                                               nop                                          #
                                               ori r2,r2,0x0040		                        #Enable Float
                                               sb r2,0x0050(r17)	                        #Store New Innate Statuses
@SCS.unit_innate_loop:                         addu r5,r17,r16		                        #r5 = Unit's Data Pointer + Counter
                                               addiu r16,r16,0x0001                         #Counter += 1
                                               lbu r2,0x004e(r5)	                        #Load Unit's X set of innate Statuses
                                               lbu r3,0x0053(r5)	                        #Load Unit's X set of status Immunities
                                               lbu r4,0x004e(r5)	                        #Load Unit's X set of Innate Statuses
                                               lbu r6,0x01bb(r5)	                        #Load Unit's X set of inflicted Statuses
                                               nor r2,r0,r2			                        #r2 = statuses that aren't innate
                                               and r3,r3,r2			                        #r3 = statuses that can be prevented
                                               or r4,r4,r6			                        #r4 = Combined Innate/Inflicted Statuses
                                               slti r2,r16,0x0005                           #
                                               sb r3,0x0053(r5)		                        #Store New Status Immunities
                                               bne r2,r0, @SCS.unit_innate_loop             #Branch if all statuses haven't been checked
                                               sb r4,0x0058(r5)		                        #Store New Current Statuses
                                               ori r16,r0,0x0018	                        #Counter = 0x18
                                               ori r18,r0,0x0080	                        #Status Check = 0x80
@SCS.new_status_loop:                          bgez r16, @SCS.skip	                        #Branch if Counter >= 0
                                               addu r2,r16,r0		                        #r2 = Counter
                                               addiu r2,r16,0x0007	                        #r2 = Counter + 7
@SCS.skip:                                     sra r2,r2,0x03		                        #Counter / 8
                                               andi r3,r16,0x0007	                        #r3 = Counter AND 7 (which bit to get)
                                               addu r2,r17,r2		                        #r2 += Unit's Data Pointer
                                               lbu r2,0x01bb(r2)	                        #Load specific Inflicted Status
                                               srav r3,r18,r3		                        #r3 = Status Check / Counter
                                               and r2,r2,r3			                        #Inflicted Status AND Status Check / 2^(Counter / 8)
                                               beq r2,r0, @SCS.new_status_loop_prep         #Branch if status is not present
                                               addu r2,r17,r16		                        # r2 = Unit's Data Pointer + Counter
                                               lbu r2,0x0045(r2)	                        #Load Status's CT
                                               nop                                          #
                                               bne r2,r0, @SCS.new_status_loop_prep         #Branch if there is still CT left
                                               addu r4,r17,r0		                        #r4 = Unit's Data Pointer
                                               addu r5,r16,r0		                        #r5 = Counter
                                               jal @Actual_Status_CT_Setting		                        #Status CT Setting
                                               addu r6,r0,r0		                        #r6 = 0 (Initialization?)
@SCS.new_status_loop_prep:                     addiu r16,r16,0x0001                         #Counter += 1
                                               slti r2,r16,0x0028                           #
                                               bne r2,r0, @SCS.new_status_loop              #Branch if all statuses haven't been checked
                                               nop                                          #
                                               lw r31,0x001c(r29)                           #
                                               lw r18,0x0018(r29)                           #
                                               lw r17,0x0014(r29)                           #
                                               lw r16,0x0010(r29)                           #
                                               addiu r29,r29,0x0020                         #
                                               jr r31                                       #
                                               nop                                          #
#/code

										@Set_Status_RSM_WORLD:  #SSRSMW  #code
0x0005d5bc:                                    addiu r29,r29,0xffe8                         #
                                               sw r31,0x0010(r29)                           #
                                               ori r5,r0,0x0001		                        #r5 = 1 (Initialization?)
                                               jal @Calculate_Status_RSM                    #Status Setting/Checking + Equip/R/S/M Stats
                                               addu r6,r0,r0		                        #r6 = 0 (Statuses already set?)
                                               lw r31,0x0010(r29)                           #
                                               addiu r29,r29,0x0018                         #
                                               jr r31                                       #
                                               nop                                          #
#/code

										@Set_Status_RSM_BATTLE: #SSRSMB #0x0005d5e0 #code
                                               addiu r29,r29,0xffe8                         #
                                               sw r31,0x0010(r29)                           #
                                               addu r5,r0,r0		                        #r5 = 0 (Not Initializing?)
                                               jal @Calculate_Status_RSM                    #Status Setting/Checking + Equip/R/S/M Stats
                                               addu r6,r0,r0		                        #r6 = 0 (Statuses already set?)
                                               lw r31,0x0010(r29)                           #
                                               addiu r29,r29,0x0018                         #
                                               jr r31                                       #
                                               nop                                          #
#/code
											   
                                        @Status_Status_RSM_Unused:  #SSRSMU #unused #code
0x0005d604:                                    addiu r29,r29,0xffe8                         #
                                               sw r31,0x0010(r29)                           #
                                               addu r5,r0,r0		                        #r5 = 0 (Not Initializing?)
                                               jal @Calculate_Status_RSM                    #Status Setting/Checking + Equip/R/S/M Stats
                                               ori r6,r0,0x0001		                        #r6 = 1 (Statuses not set yet?)
                                               lw r31,0x0010(r29)                           #
                                               addiu r29,r29,0x0018                         #
                                               jr r31                                       #
                                               nop                                          #
#/code

										@Calculate_Status_RSM:  #CSRSM #0x0005d628  #code
                                               addiu r29,r29,0xffc8                         #
                                               sw r17,0x0024(r29)                           #
                                               addu r17,r4,r0		                        #r17 = Unit's Data Pointer
                                               sw r18,0x0028(r29)                           #
                                               addu r18,r5,r0		                        #r18 = Initialization Flag?
                                               sw r19,0x002c(r29)                           #
                                               sw r31,0x0034(r29)                           #
                                               sw r20,0x0030(r29)                           #
                                               sw r16,0x0020(r29)                           #
                                               lbu r20,0x018a(r17)	                        #Load Unit's ID
                                               jal 0x0005e744		                        #Store Current Statuses
                                               addu r19,r6,r0		                        #r19 = Statuses Set Flag?
                                               addu r16,r0,r0		                        #Counter = 0
                                               addiu r5,r29,0x0010	                        #r5 = Pointer to temp. stored inflicted statuses
                                               addiu r4,r29,0x0018	                        #r4 = Pointer to temp. stored statuses
@CSRSM.status_store_loop:                      addu r3,r17,r16		                        #r3 = Unit's Data Pointer
                                               lbu r2,0x0058(r3)	                        #Load Unit's X set of Statuses
                                               addiu r16,r16,0x0001	                        #Counter ++
                                               sb r2,0x0000(r4)		                        #Store Statuses Temorarily
                                               lbu r2,0x01bb(r3)	                        #Load Unit's X set of Inflicted Statuses
                                               addiu r4,r4,0x0001	                        #Temp Stored Status Pointer ++
                                               sb r2,0x0000(r5)		                        #Store inflicted Statuses temporarily
                                               slti r2,r16,0x0005                           #
                                               bne r2,r0, @CSRSM.status_store_loop          #Branch if all statuses haven't been stored
                                               addiu r5,r5,0x0001	                        #Temp Stored Inflicted Status Pointer ++
                                               lbu r2,0x0003(r17)	                        #Load Unit's Job ID
                                               addiu r5,r17,0x004a	                        #r5 = Unit's Data Pointer + 0x4a (Equippable Items)
                                               sll r16,r2,0x01		                        #Job ID * 2
                                               addu r16,r16,r2		                        #Job ID * 3
                                               lui r2,0x8006                                #
                                               lw r2,0x6194(r2)		                        #Load Job Data Pointer
                                               sll r16,r16,0x04		                        #Job ID * 24
                                               addu r16,r16,r2		                        #Job ID * 24 + Job Data Pointer
                                               lbu r2,0x0017(r16)	                        #Load Job's Move
                                               ori r6,r0,0x0004		                        #Limit = 4 (all 4 equippable items)
                                               sb r2,0x003a(r17)	                        #Store Job's Move into Unit's Move
                                               lbu r2,0x0018(r16)	                        #Load Job's Jump
                                               addiu r4,r16,0x0009	                        #r4 = Job Data Pointer (Equippable Items)
                                               andi r2,r2,0x007f                            #
                                               jal @Store_X_into_Y                          #Store X into Y (Job's equippable items into Unit's)
                                               sb r2,0x003b(r17)	                        #Store Job's Jump into Unit's Jump
                                               addiu r4,r16,0x001a	                        #r4 = Job's Data Pointer (Innate Statuses)
                                               addiu r5,r17,0x004e	                        #r5 = Unit's Data Pointer (Innate Statuses)
                                               jal @Store_X_into_Y                          #Store X Into Y (Job's Statuses into Unit's)
                                               ori r6,r0,0x000f		                        #Limit = f (all three status groups)
                                               addiu r4,r16,0x0029	                        #r4 = Job's Data Pointer (Elemental Resistances)
                                               addiu r5,r17,0x006d	                        #r5 = Unit's Data Pointer (Elemental Resistances)
                                               jal @Store_X_into_Y                          #Store X into Y (Job's Elemental Resistances into Unit's)
                                               ori r6,r0,0x0004		                        #Limit = 4 (all elemental resistances)
                                               addu r4,r17,r0		                        #r4 = Unit's Data Pointer
                                               jal @Enable_R/S/M_Flags                      #Enable Unit's R/S/M Flags
                                               sb r0,0x0071(r17)	                        #Store Unit's Elements Strengthened = 0
                                               addu r4,r17,r0		                        #r4 = Unit's Data Pointer
                                               jal @Move_Jump_Calculation                   #Move/Jump +X Calculation
                                               ori r5,r0,0x0001		                        #r5 = 1 (Don't set Current HP/MP to Max)
                                               jal @Equipment_Stat_Setting                  #Equipment Stat Setting
                                               addu r4,r17,r0		                        #r4 = Unit's Data Pointer
                                               addu r4,r17,r0		                        #r4 = Unit's Data Pointer
                                               jal @Equipment_Attribute_Setting             #Equipment Attribute Setting
                                               addu r5,r0,r0		                        #Level UP Check = 0 (No Level UP, just stat setting)
                                               jal @Equippable_Item_Setting                 #Equippable item setting (Support/Female-only)
                                               addu r4,r17,r0		                        #r4 = Unit's Data Pointer
                                               addiu r4,r29,0x0010	                        #r4 = Pointer to temp. stored Inflicted Statuses
                                               addu r3,r17,r0		                        #r3 = Unit's Data Pointer
                                               addiu r5,r29,0x0015	                        #r5 = Temp Stored Inflicted Status Limit (for loop)
@CSRSM.2nd_loop:                               beq r19,r0, @CSRSM.skip                      #Branch if Statuses have been set?
                                               nop                                          #
                                               lbu r2,0x0058(r3)	                        #Load Unit's X set of statuses
                                               j @CSRSM.2nd_loop_prep                       #(Inflicted Statuses = Current Statuses)
                                               sb r2,0x01bb(r3)		                        #Store X set of statuses in Unit's Inflicted Statuses
@CSRSM.skip:                                   lbu r2,0x0000(r4)	                        #Load X set of stored statuses
                                               nop				                            #(Inflicted Statuses = Inflicted Statuses)
                                               sb r2,0x01bb(r3)		                        #Store X set of statuses in Unit's Inflicted Statuses
@CSRSM.2nd_loop_prep:                          addiu r4,r4,0x0001	                        #Pointer to Temp stored Inflicted Statuses += 1
                                               slt r2,r4,r5                                 #
                                               bne r2,r0, @CSRSM.2nd_loop                   #Branch if all statuses haven't been stored
                                               addiu r3,r3,0x0001	                        #Unit's Data Pointer += 1
                                               addu r4,r17,r0		                        #r4 = Unit's Data Pointer
                                               lbu r16,0x0002(r17)	                        #Load Unit's Party ID
                                               ori r2,r0,0x00ff                             #
                                               jal @Status_CT_Setting                       #Float/Current Statuses/Status Immunities/Status CT
                                               sb r2,0x0002(r17)	                        #Store Party ID = FF
                                               addu r4,r17,r0		                        #r4 = Unit's Data Pointer
                                               jal 0x0005e744		                        #Store Current Statuses
                                               sb r16,0x0002(r17)	                        #Store Unit's Party ID
                                               bne r18,r0, @CSRSM.end                       #Branch if Initializing Data?
                                               lui r3,0xcccc                                #
                                               lhu r2,0x002a(r17)	                        #Load Unit's Max HP
                                               ori r3,r3,0xcccd                             #
                                               multu r2,r3			                        #Max HP * 0.8
                                               lhu r3,0x0028(r17)	                        #Load Unit's Current HP
                                               mfhi r2			                            #r2 = Max HP * 0.8
                                               srl r2,r2,0x02		                        #r2 = Max HP * 0.8 / 4 (or Max HP / 5)
                                               andi r2,r2,0xffff                            #
                                               sltu r2,r2,r3                                #
                                               bne r2,r0, @CSRSM.disable_critical           #Branch if not in Critical
                                               nop                                          #
                                               lbu r2,0x01bd(r17)                           #Load Unit's 3rd set of Inflicted Statuses
                                               j @CSRSM.store_critical_flag                                 #
                                               ori r2,r2,0x0001		                        #Enable Critical
@CSRSM.disable_critical:                       lbu r2,0x01bd(r17)	                        #Load Unit's 3rd set of Inflicted Statuses
                                               nop                                          #
                                               andi r2,r2,0x00fe	                        #Disable Critical
@CSRSM.store_critical_flag:                    sb r2,0x01bd(r17)	                        #Store Unit's New Inflicted Statuses
                                               jal 0x0005e744		                        #Store Current Statuses
                                               addu r4,r17,r0		                        #r4 = Unit's Data Pointer
                                               addu r16,r0,r0		                        #Counter = 0
                                               ori r18,r0,0x0001	                        #Counter2 = 1
@CSRSM.3rd_loop_start:                         bgez r16, @CSRSM.skip_2                      #Branch if Counter >= 0
                                               addu r2,r16,r0		                        #r2 = Counter
                                               addiu r2,r16,0x0007	                        #Counter += 7
@CSRSM.skip_2:                                 sra r2,r2,0x03		                        #Counter / 8
                                               andi r4,r16,0x0007                           #
                                               ori r3,r0,0x0080		                        #Status Check = 80
                                               srav r3,r3,r4		                        #r3 = Status Check / Counter
                                               addu r4,r29,r2		                        #r4 = Counter / 8 + Temp Current Statuses Pointer
                                               addu r2,r17,r2		                        #r2 = Unit's Data Pointer += Counter / 8
                                               lbu r4,0x0018(r4)	                        #Load Temp Stored Current Statuses
                                               lbu r2,0x0058(r2)	                        #Load Unit's Current Statuses
                                               and r4,r4,r3                                 #
                                               bne r19,r0, @CSRSM.status_present_check      #Branch if Statuses haven't been set yet?
                                               and r2,r2,r3                                 #
                                               beq r4,r2, @CSRSM.3rd_loop_prep              #Branch if Temp Stored Status is already present
                                               nop                                          #
@CSRSM.status_present_check:                   beq r2,r0, @CSRSM.status_not_present         #Branch if Status is not present
                                               addu r4,r18,r0		                        #r4 = Counter2
                                               beq r19,r0, @CSRSM.set_r4_r5                 #Branch if Statuses have been set?
                                               addu r4,r17,r0		                        #r4 = Unit's Data Pointer
                                               addu r5,r16,r0		                        #r5 = Counter
                                               jal @Actual_Status_CT_Setting		                        #Status CT Setting
                                               addu r6,r0,r0		                        #r6 = 0 (Not Initializing?)
@CSRSM.set_r4_r5:                              addu r4,r18,r0		                        #r4 = Counter2
                                               j @CSRSM.status_flag_check                   #
                                               ori r5,r0,0x0001		                        #r5 = 1 (Status Present)
@CSRSM.status_not_present:                     addu r5,r0,r0		                        #r5 = 0 (Status not Present)
@CSRSM.status_flag_check:                      jal @Status_Flag_Check                       #Determine if Status Flags can be Enabled?
                                               addu r6,r20,r0		                        #r6 = Unit's ID
@CSRSM.3rd_loop_prep:                          addiu r16,r16,0x0001	                        #Counter += 1
                                               slti r2,r16,0x0028                           #
                                               bne r2,r0, @CSRSM.3rd_loop_start             #Branch if all statuses haven't been checked
                                               addiu r18,r18,0x0001	                        #Counter2 += 1
@CSRSM.end:                                    lw r31,0x0034(r29)                           #
                                               lw r20,0x0030(r29)                           #
                                               lw r19,0x002c(r29)                           #
                                               lw r18,0x0028(r29)                           #
                                               lw r17,0x0024(r29)                           #
                                               lw r16,0x0020(r29)                           #
                                               addiu r29,r29,0x0038                         #
                                               jr r31                                       #
                                               nop                                          #
#/code

										@Level_Up_Check:  #LUC  # 0x0005d880 #code          #BATTLE.BIN only
                                               addiu r29,r29,0xffe0                         #
                                               sw r16,0x0010(r29)                           #
                                               addu r16,r4,r0		                        #r16 = Unit's Data Pointer
                                               sw r31,0x0018(r29)                           #
                                               sw r17,0x0014(r29)                           #
                                               lbu r2,0x0021(r16)	                        #Load Unit's Exp
                                               nop                                          #
                                               sltiu r2,r2,0x0064                           #
                                               bne r2,r0, @LUC.end                          #Branch if Exp < 100
                                               addu r2,r0,r0		                        #Exp = 0
                                               lbu r17,0x0022(r16)	                        #Load Unit's Level
                                               nop                                          #
                                               sltiu r2,r17,0x0063                          #
                                               beq r2,r0, @LUC.skip                         #Branch if Level < 99
                                               addu r4,r16,r0		                        #r4 = Unit's Data Pointer
                                               jal @Level_Up_Section                        #Level UP section
                                               addu r5,r0,r0		                        #r5 = 0 (Level Down Flag = False)
                                               ori r2,r0,0x0001		                        #r2 = 1 (Leveled up)
                                               addiu r3,r17,0x0001	                        #Level += 1
                                               sb r0,0x0021(r16)	                        #Store Exp = 0
                                               j @LUC.end                                   #
                                               sb r3,0x0022(r16)	                        #Store new Level
@LUC.skip:                                     ori r2,r0,0x0063		                        #r2 = 99
                                               sb r2,0x0021(r16)	                        #Store Level = 99
                                               addu r2,r0,r0		                        #r2 = 0 (no level up)
@LUC.end:                                      lw r31,0x0018(r29)                           #
                                               lw r17,0x0014(r29)                           #
                                               lw r16,0x0010(r29)                           #
                                               addiu r29,r29,0x0020                         #
                                               jr r31                                       #
                                               nop	                                        #
#/code							
										@Level_to_Specific_Level: #LtSL #0x0005d8fc #code   #WORLD.BIN only
                                               addiu r29,r29,0xfff8                         #
                                               addu r8,r4,r0		                        #r8 = Party Data Pointer
                                               lbu r4,0x0016(r8)		                    #Load Party Level
                                               lbu r3,0x0002(r8)		                    #Load Party Job ID
                                               addu r6,r4,r5		                        #Level = Party Level + Chosen Level
                                               sll r2,r3,0x01		                        #ID * 2
                                               addu r2,r2,r3		                        #ID * 3
                                               lui r3,0x8006                                #
                                               lw r3,0x6194(r3)		                        #Load Job Data Pointer
                                               sll r2,r2,0x04		                        #ID * 48
                                               addu r2,r2,r3                                #
                                               addiu r13,r2,0x000d		                    #r13 = Pointer to Job's HP Growth
                                               sltiu r2,r6,0x0064                           #
                                               bne r2,r0, @LtSL.less_then_lvl_100           #Branch if Level < 100
                                               addiu r14,r8,0x0019		                    #r14 = Pointer to Party Raw HP
                                               ori r6,r0,0x0063		                        #Level = 99
@LtSL.less_then_lvl_100:                       subu r11,r6,r4		                        #Level - Party Level (Chosen Level essentially)
                                               blez r11, @LtSL.end		                    #Branch if Level <= 0 (will happen at chosen level 99)
                                               addu r2,r6,r0		                        #r2 = Level
                                               blez r11, @LtSL.load_party_level             #Branch if Level <= 0
                                               addu r9,r0,r0		                        #Counter = 0
                                               lui r12,0x00ff                               #
                                               ori r12,r12,0xffff		                    #Raw Cap = 0xFFFFFF
@LtSL.party_level_loop:                        addu r5,r14,r0		                        #r5 = Pointer to Party Raw HP
                                               addu r7,r13,r0		                        #r7 = Pointer to Job's HP Growth
                                               addiu r10,r5,0x000f		                    #r10 = Pointer to Party's Unlocked Jobs (Limit)
@LtSL.raw_stat_loop:                           lbu r2,0x0001(r5)		                    #Load Raw Stat Byte 2
                                               lbu r6,0x0016(r8)		                    #Load Party Level
                                               lbu r4,0x0000(r5)		                    #Load Raw Stat Byte 1
                                               lbu r3,0x0002(r5)		                    #Load Raw Stat Byte 3
                                               sll r2,r2,0x08                               #
                                               addu r4,r4,r2                                #
                                               sll r3,r3,0x10                               #
                                               lbu r2,0x0000(r7)		                    #Load Stat Growth
                                               nop                                          #
                                               bne r2,r0, @LtSL.calculate_raw_stat          #Branch if Growth != 0
                                               addu r4,r4,r3		                        #r4 = Full Raw Stat
                                               j @LtSL.min_growth_start                                 #
                                               addiu r2,r6,0x0001                           #r2 = Level + 1 (min of 1 growth)
@LtSL.calculate_raw_stat:                      addu r2,r6,r2		                        #r2 = Level + Stat Growth
@LtSL.min_growth_start:                        divu r4,r2			                        #Raw Stat / (Level + Growth)
                                               mflo r3			                            #r3 = Raw Bonus
                                               nop                                          #
                                               addu r4,r4,r3		                        #Raw Stat += Raw Bonus
                                               sltu r2,r12,r4                               #
                                               beq r2,r0, @LtSL.skip                        #Branch if Raw Stat > Raw Cap
                                               addiu r7,r7,0x0002                           #Growth Pointer += 2
                                               lui r4,0x00ff                                #
                                               ori r4,r4,0xffff		                        #Raw Stat = FFFFFF
@LtSL.skip:                                    srl r2,r4,0x08                               #
                                               sb r2,0x0001(r5)		                        #Store Raw Stat Byte 2
                                               srl r2,r4,0x10                               #
                                               sb r4,0x0000(r5)		                        #Store Raw Stat Byte 1
                                               sb r2,0x0002(r5)		                        #Store Raw Stat Byte 3
                                               addiu r5,r5,0x0003	                        #Raw Pointer += 3
                                               slt r2,r5,r10                                #
                                               bne r2,r0, @LtSL.raw_stat_loop               #Branch if all Raws haven't been Increased
                                               nop                                          #
                                               lbu r2,0x0016(r8)	                        #Load Party Level
                                               addiu r9,r9,0x0001	                        #Counter ++
                                               addiu r2,r2,0x0001	                        #Level ++
                                               sb r2,0x0016(r8)	                            #Store new Party Level
                                               slt r2,r9,r11                                #
                                               bne r2,r0, @LtSL.party_level_loop            #Branch if Current Level < End Level
                                               nop                                          #
@LtSL.load_party_level:                        lbu r2,0x0016(r8)	                        #Load Unit's Party Level
@LtSL.end:                                     addiu r29,r29,0x0008                         #
                                               jr r31                                       #
                                               nop                                          #
#/code

                                        @Level_Up_Section:  #LUS  #0x0005da10  #code
                                               addiu r29,r29,0xffc8                         #
                                               sw r19,0x001c(r29)                           #
                                               addu r19,r4,r0                               #r19 = Unit's Data Pointer
                                               sw r22,0x0028(r29)                           #
                                               addu r22,r5,r0                               #r22 = Level Down Flag
                                               sw r21,0x0024(r29)                           #
                                               addiu r21,r19,0x0072		                    #r21 = Unit's Raw Stat Pointer
                                               sw r18,0x0018(r29)                           #
                                               addu r18,r21,r0                              #r18 = Unit's Raw Stat Pointer
                                               sw r20,0x0020(r29)                           #
                                               addiu r20,r19,0x0081		                    #r20 = Unit's Raw Growth Pointer
                                               sw r31,0x0030(r29)                           #
                                               sw r23,0x002c(r29)                           #
                                               sw r17,0x0014(r29)                           #
                                               sw r16,0x0010(r29)                           #
                                               lbu r23,0x0022(r19)		                    #Load Unit's Level
@LUS.raw_stat_loop:                            lbu r4,0x0001(r18)		                    #Load Second byte of Raw Stat
                                               lbu r17,0x0000(r20)		                    #Load Stat Growth
                                               lbu r3,0x0000(r18)		                    #Load first byte of Raw Stat
                                               lbu r2,0x0002(r18)		                    #Load third byte of Raw Stat
                                               sll r4,r4,0x08		                        #Raw Stat 2 * 100h
                                               addu r3,r3,r4		                        #Raw Stat 2 * 100h + Raw Stat 1
                                               sll r2,r2,0x10		                        #Raw Stat 3 * 10000h
                                               addu r16,r3,r2		                        #r16 = Full Raw Stat (or lw, sll 0x08, srl 0x08)
                                               bne r17,r0, @LUS.get_random_number                        #Branch if Stat Growth != 0
                                               addu r2,r17,r0		                        #r2 = Stat Growth
                                               ori r2,r0,0x0001		                        #r2 = 1 (Min 1 growth)
@LUS.get_random_number:                        jal @Random_Number                           #Random Number Generator
                                               addu r17,r2,r23		                        #r17 = Stat Growth + Level
                                               beq r22,r0, @LUS.level_down_skip             #Branch if not Leveling Down
                                               nop                                          #
                                               divu r16,r17                                 #
                                               mflo r2                                      #r2 = Raw Stat / (Stat Growth + Level)
                                               j @LUS.calculate_raw_stat_change                                 #
                                               subu r16,r16,r2		                        #Raw Stat -= Raw Stat / (Stat Growth + Level)
@LUS.level_down_skip:                          divu r16,r17                                 #
                                               mflo r2                                      #r2 = Raw Stat / (Stat Growth + Level)
                                               nop                                          #
                                               addu r16,r16,r2		                        #Raw Stat += Raw Stat / (Stat Growth + Level)
@LUS.calculate_raw_stat_change:                lui r2,0x00ff                                #
                                               ori r2,r2,0xffff		                        #r2 = ffffff
                                               sltu r2,r2,r16                               #
                                               beq r2,r0, @LUS.skip_max_raw_stat            #Branch if ffffff < Raw Stat
                                               addiu r20,r20,0x0002		                    #Unit's Growth Pointer += 2
                                               lui r16,0x00ff                               #
                                               ori r16,r16,0xffff		                    #Raw Stat = ffffff
@LUS.skip_max_raw_stat:                        srl r2,r16,0x08                              #Raw Stat / 100
                                               sb r2,0x0001(r18)		                    #Store Raw Stat 2
                                               srl r2,r16,0x10                              #Raw Stat / 10000
                                               sb r16,0x0000(r18)		                    #Store Raw Stat 1
                                               sb r2,0x0002(r18)		                    #Store Raw Stat 3
                                               addiu r18,r18,0x0003		                    #Unit's Raw Stat Pointer += 3
                                               addiu r2,r21,0x000f		                    #Unit's Raw Stat Pointer += f
                                               slt r2,r18,r2                                #
                                               bne r2,r0, @LUS.raw_stat_loop                #Branch if Current Pointer < Max
                                               nop                                          #
                                               jal @Set_Status_RSM_BATTLE                   #Status Setting/Checking Prep (Not Initializing, Statuses set?)
                                               addu r4,r19,r0		                        #r4 = Unit's Data Pointer
                                               lhu r3,0x0028(r19)		                    #Load Unit's HP
                                               lhu r2,0x002a(r19)		                    #Load Unit's Max HP
                                               nop                                          #
                                               sltu r2,r2,r3                                #
                                               beq r2,r0, @LUS.hp_skip                      #Branch if Max HP >= Current HP
                                               nop                                          #
                                               lhu r2,0x002a(r19)		                    #Load Unit's Max HP
                                               nop                                          #
                                               sh r2,0x0028(r19)		                    #Store Current HP = Max HP
@LUS.hp_skip:                                  lhu r3,0x002c(r19)		                    #Load Unit's MP
                                               lhu r2,0x002e(r19)		                    #Load Unit's Max MP
                                               nop                                          #
                                               sltu r2,r2,r3                                #
                                               beq r2,r0, @LUS.end		                    #Branch if Max MP >= Current MP
                                               nop                                          #
                                               lhu r2,0x002e(r19)		                    #Load Unit's Max MP
                                               nop                                          #
                                               sh r2,0x002c(r19)		                    #Store Current MP = Max MP
@LUS.end:                                      lw r31,0x0030(r29)                           #
                                               lw r23,0x002c(r29)                           #
                                               lw r22,0x0028(r29)                           #
                                               lw r21,0x0024(r29)                           #
                                               lw r20,0x0020(r29)                           #
                                               lw r19,0x001c(r29)                           #
                                               lw r18,0x0018(r29)                           #
                                               lw r17,0x0014(r29)                           #
                                               lw r16,0x0010(r29)                           #
                                               addiu r29,r29,0x0038                         #
                                               jr r31                                       #
                                               nop                                          #
#/code

										@Actual_Status_CT_Setting:  #ASCS  # 0x0005db70  #code
                                               ori r2,r0,0x0002		                        #r2 = 2
                                               bne r5,r2, @ASCS.death_skip                  #Branch if Counter != 2 (Death)
                                               addu r7,r4,r0		                        #r7 = Unit's Data Pointer
                                               lbu r2,0x0005(r7)	                        #Load Unit's Battle Flags
                                               nop                                          #
                                               andi r2,r2,0x0004                            #
                                               bne r2,r0, @ASCS.store_death_counter         #Branch if Unit is Immortal
                                               ori r2,r0,0x00ff		                        #r2 = ff
                                               lbu r2,0x0006(r7)	                        #Load Unit's Gender Byte
                                               nop                                          #
                                               andi r2,r2,0x0009                            #
                                               bne r2,r0, @ASCS.store_death_counter         #Branch if Unit has Load/Save Formation
                                               ori r2,r0,0x00ff		                        #r2 = ff
                                               ori r2,r0,0x0003		                        #r2 = 3
@ASCS.store_death_counter:                     sb r2,0x0007(r7)		                        #Store Unit's Death Counter = 3 or ff
@ASCS.death_skip:                              addiu r4,r5,0xffe8	                        #r4 = Counter - 0x18
                                               sltiu r2,r4,0x0010                           #
                                               beq r2,r0, @ASCS.end	                        #Branch if Counter != last 16 statuses (not a CT status)
                                               addu r2,r0,r0		                        #r2 = 0
                                               beq r6,r0, @ASCS.skip                        #Branch if Not Initializing Data?
                                               addu r8,r4,r0		                        #r8 = Counter - 0x18
                                               addu r2,r7,r8		                        #r2 = Unit's Data Pointer + Counter - 0x18
                                               sb r0,0x005d(r2)		                        #Store X Status' CT = 0
                                               j @ASCS.end                                  #
                                               addu r2,r0,r0		                        #r2 = 0
@ASCS.skip:                                    ori r2,r0,0x000f		                        #r2 = f
                                               bne r8,r2, @ASCS.not_death_sentence          #Branch if Status Checked isn't Death Sentence
                                               addu r2,r0,r0		                        #r2 = 0
                                               lbu r2,0x006c(r7)	                        #Load Unit's Death Sentence CT
                                               nop                                          #
                                               bne r2,r0, @ASCS.end	                        #Branch if DS CT != 0 (Check if already inflicted)
                                               addiu r2,r0,0xffff	                        #r2 = ffffffff
                                               addu r2,r0,r0		                        #r2 = 0
@ASCS.not_death_sentence:                      sll r3,r5,0x04		                        #r3 = Counter * 16
                                               lui r1,0x8006                                #
                                               addu r1,r1,r3                                #
                                               lbu r4,0x5de7(r1)	                        #Load Status's CT
                                               addu r3,r7,r8		                        #r3 = Unit's Data Pointer + Counter - 0x18
                                               sb r4,0x005d(r3)		                        #Store Unit's Status's CT
@ASCS.end:                                     jr r31                                       #
                                               nop                                          #
#/code
											   
                                        @Calculate_Unlocked_Jobs:  #CUJ  #0x0005dc14  #code
                                               addiu r29,r29,0xffe8                         #
                                               addu r3,r29,r0		                        #Counter = Stack Pointer
                                               addiu r6,r29,0x000a		                    #Limit = Stack Pointer + 10
@CUJ.loop:                                     lbu r2,0x0000(r4)		                    #Load Unit's Job Levels
                                               nop                                          #
                                               sb r2,0x0000(r3)                             #Store Unit's Job Levels
                                               addiu r3,r3,0x0001		                    #Counter ++
                                               slt r2,r3,r6                                 #
                                               bne r2,r0, @CUJ.loop		                    #Branch if Counter < Limit
                                               addiu r4,r4,0x0001		                    #Job Pointer ++
                                               andi r2,r5,0x0040                            #
                                               beq r2,r0, @CUJ.1st_female_skip              #Branch if Unit is not Female
                                               andi r2,r5,0x0080                            #
                                               lbu r2,0x0008(r29)		                    #Load Unit's Calc/Bard Job Levels
                                               nop                                          #
                                               ori r2,r2,0x000f                             #Bard Level doesn't exist
                                               sb r2,0x0008(r29)		                    #Store new Job Levels
                                               andi r2,r5,0x0080                            #
@CUJ.1st_female_skip:                          beq r2,r0, @CUJ.1st_male_skip                #Branch if Unit is not Male
                                               andi r2,r5,0x0020                            #
                                               lbu r2,0x0009(r29)		                    #Load Unit's Dancer/Mime Job Levels
                                               nop                                          #
                                               ori r2,r2,0x00f0                             #Dancer Level doesn't exist
                                               sb r2,0x0009(r29)		                    #Store new Job Levels
                                               andi r2,r5,0x0020                            #
@CUJ.1st_male_skip:                            bne r2,r0, @CUJ.end		                    #Branch if Unit is a monster
                                               addu r2,r0,r0		                        #r2 = 0
                                               lui r10,0x0080		                        #Current Unlock Check = 0x800000
                                               lui r11,0x0080		                        #Jobs Unlocked = 0x800000 (start w/ squire)
                                               addu r14,r0,r0		                        #Counter = 0
                                               lui r13,0x8006                               #
                                               addiu r13,r13,0x60c4                         #
                                               srl r2,r10,0x1f                              #
@CUJ.job_loop:                                 addu r2,r10,r2                               #
                                               sra r10,r2,0x01		                        #Current Unlock Check / 2
                                               addu r9,r0,r0		                        #r9 = 0
                                               addu r7,r29,r0		                        #r7 = Stack Pointer
                                               addu r8,r13,r0		                        #r8 = Job Unlock Requirements Pointer
                                               addiu r12,r29,0x000a		                    #r12 = Stack Pointer + 10
@CUJ.job_level_loop:                           lbu r4,0x0000(r8)		                    #Load Job Unlock Requirements
                                               lbu r6,0x0000(r7)		                    #Load Job Levels
                                               andi r3,r4,0x00f0		                    #r3 = high nybble job requirement
                                               andi r2,r6,0x00f0		                    #r2 = high nybble job level
                                               sltu r2,r2,r3                                #
                                               bne r2,r0, @CUJ.1st_skip                     #Branch if Level < requirement
                                               andi r3,r4,0x000f		                    #r3 = low nybble job requirement
                                               andi r2,r6,0x000f		                    #r2 = low nybble job level
                                               sltu r2,r2,r3                                #
                                               beq r2,r0, @CUJ.2nd_skip                     #Branch if Level >= requirement
                                               nop                                          #
@CUJ.1st_skip:                                 j @CUJ.job_unlock_check                      #
                                               ori r9,r0,0x0001                             #r9 = 1 (Job can't be unlocked)
@CUJ.2nd_skip:                                 addiu r7,r7,0x0001		                    #Stack Pointer ++
                                               slt r2,r7,r12                                #
                                               bne r2,r0, @CUJ.job_level_loop               #Branch if Stack Pointer < SP + 10
                                               addiu r8,r8,0x0001		                    #Job Unlock Requirements Pointer ++
@CUJ.job_unlock_check:                         bne r9,r0, @CUJ.job_loop_prep                #Branch if Job can't be unlocked
                                               addiu r13,r13,0x000a		                    #Job Unlock Requirements Pointer += 10
                                               or r11,r11,r10                               #Unlock Job for the unit
@CUJ.job_loop_prep:                            addiu r14,r14,0x0001		                    #Counter ++
                                               slti r2,r14,0x0013                           #
                                               bne r2,r0, @CUJ.job_loop                     #Branch if Counter < 19
                                               srl r2,r10,0x1f                              #
                                               andi r2,r5,0x0080                            #
                                               beq r2,r0, @CUJ.2nd_female_skip              #Branch if Unit is Female
                                               lui r2,0x00ff                                #
                                               ori r2,r2,0xffd0		                        #
                                               and r11,r11,r2                               #Disable Dancer
@CUJ.2nd_female_skip:                          andi r2,r5,0x0040                            #
                                               beq r2,r0, @CUJ.2nd_male_skip                #Branch if Unit is Male
                                               lui r2,0x00ff                                #
                                               ori r2,r2,0xffb0                             #
                                               and r11,r11,r2		                        #Disable Bard
@CUJ.2nd_male_skip:                            addu r2,r11,r0		                        #r2 = Unlocked Jobs
@CUJ.end:                                      addiu r29,r29,0x0018                         #
                                               jr r31                                       #
                                               nop                                          #