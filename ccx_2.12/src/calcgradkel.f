!
!     CalculiX - A 3-dimensional finite element program
!              Copyright (C) 1998-2015 Guido Dhondt
!
!     This program is free software; you can redistribute it and/or
!     modify it under the terms of the GNU General Public License as
!     published by the Free Software Foundation(version 2);
!     
!
!     This program is distributed in the hope that it will be useful,
!     but WITHOUT ANY WARRANTY; without even the implied warranty of 
!     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
!     GNU General Public License for more details.
!
!     You should have received a copy of the GNU General Public License
!     along with this program; if not, write to the Free Software
!     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
!
      subroutine calcgradkel(nef,lakonf,ipnei,vfa,area,xxn,gradkel,
     &  neifa,volume)
!
!     calculation of the gradient of the velocity at the center
!     of the elements from the velocity values at the neighboring
!     faces
!
      implicit none
!
      character*8 lakonf(*)
!
      integer nef,ipnei(*),neifa(*),i,l,indexf,ifa,numfaces
!
      real*8 vfa(0:7,*),area(*),xxn(3,*),gradkel(3,*),volume(*)
!
c$omp parallel default(none)
c$omp& shared(nef,ipnei,lakonf,neifa,gradkel,vfa,area,xxn,volume)
c$omp& private(i,indexf,numfaces,ifa)
c$omp do
      do i=1,nef
c         indexf=ipnei(i)
c         do j=1,ipnei(i+1)-ipnei(i)
c            indexf=indexf+1
         do indexf=ipnei(i)+1,ipnei(i+1)
            ifa=neifa(indexf)
            do l=1,3
               gradkel(l,i)=gradkel(l,i)+
     &              vfa(6,ifa)*area(ifa)*xxn(l,indexf)
            enddo
         enddo
!     
!     dividing by the volume of the element
!     
         do l=1,3
            gradkel(l,i)=gradkel(l,i)/volume(i)
         enddo
      enddo
c$omp end do
c$omp end parallel
!            
      return
      end
