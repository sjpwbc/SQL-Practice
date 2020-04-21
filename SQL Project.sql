/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT name
  FROM Facilities
 WHERE membercost > 0

The facilities that do charge a fee to members is: 
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court



/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(*)
  FROM Facilities
 WHERE membercost = 0

There are four facilities that do not charge a fee to members.



/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, 
       name, 
       membercost, 
       monthlymaintenance
  FROM Facilities
 WHERE membercost > 0
   AND membercost < ( .2 ) * monthlymaintenance

The facilities that charge a fee to members that is 
less than 20% of the facility's monthly maintenance cost are:

Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court 



/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT *
  FROM Facilities
 WHERE facid IN (1, 5)



/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, 
       monthlymaintenance,
       CASE WHEN monthlymaintenance > 100 THEN 'expensive'
       ELSE 'cheap' END AS label
  FROM Facilities

The facilities that were labelled as 'expensive' were: 
Tennis Court 1 (monthly maintenance cost of 200)
Tennis court 2 (monthly maintenance cost of 200)
Massage Room 1 (monthly maintenance cost of 3000)
Massage Room 2 (monthly maintenance cost of 3000)

The facilities that were labelled as 'cheap' were:
Badminton Court (monthly maintenance cost of 50)
Table Tennis (monthly maintenance cost of 10)
Squash Court (monthly maintenance cost of 80)
Snooker Table (monthly maintenance cost of 15)
Pool Table (monthly maintenance cost of 15)



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT firstname, 
       surname
  FROM Members
 WHERE joindate = (SELECT MAX(joindate) FROM Members)

The first and last name of the last member who signed up is: Darren Smith.



/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT 
 CONCAT(mems.firstname, ' ', mems.surname) AS member, 
       facs.name AS facility
  FROM Members mems
  JOIN Bookings bks 
    ON mems.memid = bks.memid
  JOIN Facilities facs 
    ON bks.facid = facs.facid
 WHERE bks.facid IN (0, 1)
ORDER BY member



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT 
 CONCAT(mems.firstname, ' ', mems.surname) AS member, 
       facs.name AS facility,
       CASE WHEN mems.memid = 0 THEN bks.slots * facs.guestcost
       ELSE bks.slots * facs.membercost END AS cost
  FROM Members mems
  JOIN Bookings bks 
    ON mems.memid = bks.memid
  JOIN Facilities facs 
    ON bks.facid = facs.facid
 WHERE bks.starttime >= '2012-09-14'
   AND bks.starttime < '2012-09-15'
   AND ((mems.memid = 0
   AND bks.slots * facs.guestcost > 30)
    OR (mems.memid != 0
   AND bks.slots * facs.membercost > 30))
ORDER BY cost DESC



/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT member, 
       facility, 
       cost
  FROM
       (SELECT 
         CONCAT(mems.firstname, ' ', mems.surname) AS member, 
               facs.name AS facility,
               CASE WHEN mems.memid =0 THEN bks.slots * facs.guestcost
               ELSE bks.slots * facs.membercost END AS cost
          FROM Members mems
          JOIN Bookings bks 
            ON mems.memid = bks.memid
    INNER JOIN Facilities facs 
            ON bks.facid = facs.facid
         WHERE bks.starttime >= '2012-09-14'
           AND bks.starttime < '2012-09-15'
               ) AS bookings
 WHERE cost > 30
ORDER BY cost DESC



/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT name, 
       totalrevenue
  FROM
       (SELECT facs.name, 
       SUM(CASE WHEN memid = 0 THEN slots * facs.guestcost 
           ELSE slots * membercost END) AS totalrevenue
           FROM Bookings bks
     INNER JOIN Facilities facs 
             ON bks.facid = facs.facid
       GROUP BY facs.name
                ) AS selected_facilities
 WHERE totalrevenue <= 1000
ORDER BY totalrevenue DESC

The facilities with a total revenue less than 1000 are: Pool Table, Snooker Table, and Tennis Table.


