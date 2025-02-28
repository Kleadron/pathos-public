#include "qrad.h"

#pragma warning(disable: 4018)

// =====================================================================================
//  point_in_winding
// =====================================================================================
bool            point_in_winding(const Winding& w, const dplane_t& plane, const vec_t* const point)
{
    unsigned        numpoints = w.m_NumPoints;
    int             x;

    for (x = 0; x < numpoints; x++)
    {
        vec3_t          A;
        vec3_t          B;
        vec3_t          normal;

        VectorSubtract(w.m_Points[(x + 1) % numpoints], point, A);
        VectorSubtract(w.m_Points[x], point, B);
        CrossProduct(A, B, normal);
#ifndef HLRAD_MATH_VL
        VectorNormalize(normal);
#endif

        if (DotProduct(normal, plane.normal) < 0.0)
        {
            return false;
        }
    }

    return true;
}
#ifdef HLRAD_SNAPTOWINDING
void			snap_to_winding(const Winding& w, const dplane_t& plane, vec_t* const point)
{
	int				numpoints = w.m_NumPoints;
	int				x;
	vec_t			*p1, *p2;
	vec3_t			delta;
	vec_t			dot1, dot2, dot;
	vec3_t			bestpoint;
	vec_t			bestdist;
	bool			in = true;
	for (x = 0; x < numpoints; x++)
	{
		{
			vec3_t          A;
			vec3_t          B;
			vec3_t          normal;
			VectorSubtract(w.m_Points[(x + 1) % numpoints], point, A);
			VectorSubtract(w.m_Points[x], point, B);
			CrossProduct(A, B, normal);
			if (DotProduct(normal, plane.normal) >= 0.0)
			{
				continue;
			}
		}
		in = false;
		p1 = w.m_Points[x];
		p2 = w.m_Points[(x+1)%numpoints];
		VectorSubtract (p2, p1, delta);
		dot = DotProduct (delta, point);
		dot1 = DotProduct (delta, p1);
		dot2 = DotProduct (delta, p2);
		if (dot1 < dot && dot < dot2)
		{
			point[0] = ((dot2 - dot) * p1[0] + (dot - dot1) * p2[0]) / (dot2 - dot1);
			point[1] = ((dot2 - dot) * p1[1] + (dot - dot1) * p2[1]) / (dot2 - dot1);
			point[2] = ((dot2 - dot) * p1[2] + (dot - dot1) * p2[2]) / (dot2 - dot1);
			return;
		}
	}
	if (in)
		return;
	for (x = 0; x < numpoints; x++)
	{
		p1 = w.m_Points[x];
		VectorSubtract (p1, point, delta);
		if (x == 0 || DotProduct (delta, delta) < bestdist)
		{
			VectorCopy (p1, bestpoint);
			bestdist = DotProduct (delta, delta);
		}
	}
	if (numpoints > 0)
	{
		VectorCopy (bestpoint, point);
	}
	return;
}
void			snap_to_winding_noedge(const Winding& w, const dplane_t& plane, vec_t* const point, vec_t width)
{
	Winding *new_w = new Winding (w);
	int numpoints = w.m_NumPoints;
	int x;
	vec3_t e1, e2, n1;
	vec_t dot;
	bool wrong = false;
	for (x = 0; x < numpoints; x++)
	{
		vec3_t &p = new_w->m_Points[x];
		VectorSubtract (w.m_Points[(x+numpoints-1)%numpoints], w.m_Points[x], e1);
		VectorSubtract (w.m_Points[(x+1)%numpoints], w.m_Points[x], e2);
		if (VectorNormalize (e1) == 0)
		{
			wrong = true;
			break;
		}
		if (VectorNormalize (e2) == 0)
		{
			wrong = true;
			break;
		}
		CrossProduct (plane.normal, e1, n1);
		dot = DotProduct (e1, e2);
		if (dot >= 1 - NORMAL_EPSILON)
		{
			wrong = true;
			break;
		}
		if (dot < -1)
			dot = -1;
		VectorMA (p, width * sqrt ((1+dot)/(1-dot)), e1, p);
		VectorMA (p, width, n1, p);
	}
	{
		vec3_t center;
		w.getCenter (center);
		if (!point_in_winding (*new_w, plane, center))
			wrong = true;
	}
	if (wrong)
	{
		if (DEVELOPER_LEVEL_FLUFF <= g_developer)
		{
			Log ("Bad face winding (normal=%f,%f,%f) @\n", plane.normal[0], plane.normal[1], plane.normal[2]);
			w.Print ();
		}
		snap_to_winding (w, plane, point);
		vec3_t delta;
		w.getCenter(delta);
		VectorSubtract(delta, point, delta);
		if (DotProduct (delta, delta) > 1)
			VectorNormalize (delta);
		VectorAdd (delta, point, point);
	}
	else
		snap_to_winding (*new_w, plane, point);
	delete new_w;
}
#endif
#ifdef HLRAD_NUDGE_VL
bool            point_in_winding_noedge(const Winding& w, const dplane_t& plane, const vec_t* const point, vec_t width)
{
    unsigned        numpoints = w.m_NumPoints;
    int             x;

    for (x = 0; x < numpoints; x++)
    {
        vec3_t          A;
        vec3_t          B;
        vec3_t          normal;
		vec3_t			edge;
		VectorSubtract(w.m_Points[(x + 1) % numpoints], w.m_Points[x], edge);

        VectorSubtract(w.m_Points[(x + 1) % numpoints], point, A);
        VectorSubtract(w.m_Points[x], point, B);
        CrossProduct(A, B, normal);
		vec_t dot = DotProduct (normal, plane.normal);

        if (dot < 0 || dot * dot <= width * width * DotProduct (edge, edge))
        {
            return false;
        }
    }

    return true;
}
#endif
#ifdef HLRAD_POINT_IN_EDGE_FIX
bool			point_in_winding_percentage(const Winding& w, const dplane_t& plane, const vec3_t point, const vec3_t ray, double &percentage)
{
    unsigned        numpoints = w.m_NumPoints;
    int             x;

	int				inedgecount = 0;
	vec3_t			inedgedir[2];

    for (x = 0; x < numpoints; x++)
    {
        vec3_t          A;
        vec3_t          B;
        vec3_t          normal;

        VectorSubtract(w.m_Points[(x + 1) % numpoints], point, A);
        VectorSubtract(w.m_Points[x], point, B);
        CrossProduct(A, B, normal);

		if (DotProduct(normal, plane.normal) == 0.0)
		{
			if (inedgecount < 2)
				VectorSubtract(w.m_Points[(x + 1) % numpoints], w.m_Points[x], inedgedir[inedgecount]);
			inedgecount++;
		}
        if (DotProduct(normal, plane.normal) < 0.0)
        {
            return false;
        }
    }

	switch (inedgecount)
	{
	case 0:
		percentage = 1.0;
		return true;
	case 1:
		percentage = 0.5;
		return true;
	case 2:
		vec3_t tmp1, tmp2;
		vec_t dot;
		CrossProduct (inedgedir[1], ray, tmp1);
		CrossProduct (inedgedir[2], ray, tmp2);
		VectorNormalize (tmp1);
		VectorNormalize (tmp2);
		dot = DotProduct (tmp1, tmp2);
		dot = dot>1? 1: dot<-1? -1: dot;
		percentage = 0.5 - acos (dot) / (2 * Q_PI);
		if (percentage < 0)
			Warning ("internal error 1 in HLRAD_POINT_IN_EDGE_FIX");
		return true;
	default:
		Warning ("internal error 2 in HLRAD_POINT_IN_EDGE_FIX");
		return false;
	}
}
#endif

#ifndef HLRAD_LERP_VL
// =====================================================================================
//  point_in_wall
// =====================================================================================
bool            point_in_wall(const lerpWall_t* wall, vec3_t point)
{
    int             x;

    // Liberal use of the magic number '4' for the hardcoded winding count
    for (x = 0; x < 4; x++)
    {
        vec3_t          A;
        vec3_t          B;
        vec3_t          normal;

        VectorSubtract(wall->vertex[x], wall->vertex[(x + 1) % 4], A);
        VectorSubtract(wall->vertex[x], point, B);
        CrossProduct(A, B, normal);
#ifndef HLRAD_MATH_VL
        VectorNormalize(normal);
#endif

        if (DotProduct(normal, wall->plane.normal) < 0.0)
        {
            return false;
        }
    }
    return true;
}

// =====================================================================================
//  point_in_tri
// =====================================================================================
bool            point_in_tri(const vec3_t point, const dplane_t* const plane, const vec3_t p1, const vec3_t p2, const vec3_t p3)
{
    vec3_t          A;
    vec3_t          B;
    vec3_t          normal;

    VectorSubtract(p1, p2, A);
    VectorSubtract(p1, point, B);
    CrossProduct(A, B, normal);
#ifndef HLRAD_MATH_VL
    VectorNormalize(normal);
#endif

    if (DotProduct(normal, plane->normal) < 0.0)
    {
        return false;
    }

    VectorSubtract(p2, p3, A);
    VectorSubtract(p2, point, B);
    CrossProduct(A, B, normal);
#ifndef HLRAD_MATH_VL
    VectorNormalize(normal);
#endif

    if (DotProduct(normal, plane->normal) < 0.0)
    {
        return false;
    }

    VectorSubtract(p3, p1, A);
    VectorSubtract(p3, point, B);
    CrossProduct(A, B, normal);
#ifndef HLRAD_MATH_VL
    VectorNormalize(normal);
#endif

    if (DotProduct(normal, plane->normal) < 0.0)
    {
        return false;
    }
    return true;
}
#endif

#ifdef HLRAD_TestSegmentAgainstOpaqueList_VL
bool			intersect_linesegment_plane(const dplane_t* const plane, const vec_t* const p1, const vec_t* const p2, vec3_t point)
{
	vec_t			part1;
	vec_t			part2;
	int				i;
	part1 = DotProduct (p1, plane->normal) - plane->dist;
	part2 = DotProduct (p2, plane->normal) - plane->dist;
	if (part1 * part2 > 0 || part1 == part2)
		return false;
	for (i=0; i<3; ++i)
		point[i] = (part1 * p2[i] - part2 * p1[i]) / (part1 - part2);
	return true;
}
#else /*HLRAD_TestSegmentAgainstOpaqueList_VL*/
// =====================================================================================
//  intersect_line_plane
//      returns true if line hits plane, and parameter 'point' is filled with where
// =====================================================================================
bool            intersect_line_plane(const dplane_t* const plane, const vec_t* const p1, const vec_t* const p2, vec3_t point)
{
    vec3_t          pop;
    vec3_t          line_vector;                           // normalized vector for the line;
    vec3_t          tmp;
    vec3_t          scaledDir;
    vec_t           partial;
    vec_t           total;
    vec_t           perc;

    // Get a normalized vector for the ray
    VectorSubtract(p1, p2, line_vector);
    VectorNormalize(line_vector);

    VectorScale(plane->normal, plane->dist, pop);
    VectorSubtract(pop, p1, tmp);
    partial = DotProduct(tmp, plane->normal);
    total = DotProduct(line_vector, plane->normal);

    if (total == 0.0)
    {
        VectorClear(point);
        return false;
    }

    perc = partial / total;
    VectorScale(line_vector, perc, scaledDir);
    VectorAdd(p1, scaledDir, point);
    return true;
}

// =====================================================================================
//  intersect_linesegment_plane
//      returns true if line hits plane, and parameter 'point' is filled with where
// =====================================================================================
bool            intersect_linesegment_plane(const dplane_t* const plane, const vec_t* const p1, const vec_t* const p2, vec3_t point)
{
    unsigned        count = 0;
    if (DotProduct(plane->normal, p1) <= plane->dist)
    {
        count++;
    }
    if (DotProduct(plane->normal, p2) <= plane->dist)
    {
        count++;
    }

    if (count == 1)
    {
        return intersect_line_plane(plane, p1, p2, point);
    }
    else
    {
        return false;
    }
}
#endif /*HLRAD_TestSegmentAgainstOpaqueList_VL*/

// =====================================================================================
//  plane_from_points
// =====================================================================================
void            plane_from_points(const vec3_t p1, const vec3_t p2, const vec3_t p3, dplane_t* plane)
{
    vec3_t          delta1;
    vec3_t          delta2;
    vec3_t          normal;

    VectorSubtract(p3, p2, delta1);
    VectorSubtract(p1, p2, delta2);
    CrossProduct(delta1, delta2, normal);
    VectorNormalize(normal);
    plane->dist = DotProduct(normal, p1);
    VectorCopy(normal, plane->normal);
}

//LineSegmentIntersectsBounds --vluzacn
bool LineSegmentIntersectsBounds_r (const vec_t* p1, const vec_t* p2, const vec_t* mins, const vec_t* maxs, int d)
{
	vec_t lmin, lmax;
	const vec_t* tmp;
	vec3_t x1, x2;
	int i;
	d--;
	if (p2[d]<p1[d])
		tmp=p1, p1=p2, p2=tmp;
	if (p2[d]<mins[d] || p1[d]>maxs[d])
		return false;
	if (d==0)
		return true;
	lmin = p1[d]>=mins[d]? 0 : (mins[d]-p1[d])/(p2[d]-p1[d]);
	lmax = p2[d]<=maxs[d]? 1 : (p2[d]-maxs[d])/(p2[d]-p1[d]);
	for (i=0; i<d; ++i)
	{
		x1[i]=(1-lmin)*p1[i]+lmin*p2[i];
		x2[i]=(1-lmax)*p2[i]+lmax*p2[i];
	}
	return LineSegmentIntersectsBounds_r (x1, x2, mins, maxs, d);
}
inline bool LineSegmentIntersectsBounds (const vec3_t p1, const vec3_t p2, const vec3_t mins, const vec3_t maxs)
{
	return LineSegmentIntersectsBounds_r (p1, p2, mins, maxs, 3);
}

// =====================================================================================
//  TestSegmentAgainstOpaqueList
//      Returns true if the segment intersects an item in the opaque list
// =====================================================================================
bool            TestSegmentAgainstOpaqueList(const vec_t* p1, const vec_t* p2
#ifdef HLRAD_HULLU
					, vec3_t &scaleout
#endif
#ifdef HLRAD_OPAQUE_STYLE
					, int &opaquestyleout // light must convert to this style. -1 = no convert
#endif
					)
{
#ifdef HLRAD_OPAQUE_NODE
	int x;
#ifdef HLRAD_HULLU
	VectorFill (scaleout, 1.0);
#endif
#ifdef HLRAD_OPAQUE_STYLE
	opaquestyleout = -1;
#endif
    for (x = 0; x < g_opaque_face_count; x++)
	{
		if (!TestLineOpaque (g_opaque_face_list[x].modelnum, g_opaque_face_list[x].origin, p1, p2))
		{
			continue;
		}
#ifdef HLRAD_HULLU
		if (g_opaque_face_list[x].transparency)
		{
			VectorMultiply (scaleout, g_opaque_face_list[x].transparency_scale, scaleout);
			continue;
		}
#endif
#ifdef HLRAD_OPAQUE_STYLE
		if (g_opaque_face_list[x].style != -1 && (opaquestyleout == -1 || g_opaque_face_list[x].style == opaquestyleout))
		{
			opaquestyleout = g_opaque_face_list[x].style;
			continue;
		}
#endif
#ifdef HLRAD_HULLU
		VectorFill (scaleout, 0.0);
#endif
#ifdef HLRAD_OPAQUE_STYLE
		opaquestyleout = -1;
#endif
		return true;
	}
	return false;
#else /*HLRAD_OPAQUE_NODE*/
    unsigned        x;
    vec3_t          point;
    const dplane_t* plane;
    const Winding*  winding;
#ifdef HLRAD_TestSegmentAgainstOpaqueList_VL
	int				i;
	vec3_t			scale_one;
	vec3_t			direction;
	VectorSubtract (p1, p2, direction);
	VectorNormalize (direction);
#endif

#ifdef HLRAD_HULLU
    vec3_t	    scale = {1.0, 1.0, 1.0};
#endif
#ifdef HLRAD_POINT_IN_EDGE_FIX
	double		percentage;
#endif
#ifdef HLRAD_OPAQUE_STYLE
	opaquestyleout = -1;
#endif

#ifdef HLRAD_OPAQUE_RANGE
	bool intersects[MAX_OPAQUE_GROUP_COUNT];
	for (x = 0; x < g_opaque_group_count; x++)
	{
		intersects[x] = 
			LineSegmentIntersectsBounds (p1, p2, g_opaque_group_list[x].mins, g_opaque_group_list[x].maxs);
	}
#endif
    for (x = 0; x < g_opaque_face_count; x++)
    {
#ifdef HLRAD_OPAQUE_RANGE
		if (intersects[g_opaque_face_list[x].groupnum] == 0)
			continue;
#endif
        plane = &g_opaque_face_list[x].plane;
        winding = g_opaque_face_list[x].winding;

#ifdef HLRAD_OPACITY // AJM
        l_opacity = g_opaque_face_list[x].l_opacity;
#endif
        if (intersect_linesegment_plane(plane, p1, p2, point))
        {
#if 0
            Log
                ("Ray from (%4.3f %4.3f %4.3f) to (%4.3f %4.3f %4.3f) hits plane at (%4.3f %4.3f %4.3f)\n Plane (%4.3f %4.3f %4.3f) %4.3f\n",
                 p1[0], p1[1], p1[2], p2[0], p2[1], p2[2], point[0], point[1], point[2], plane->normal[0],
                 plane->normal[1], plane->normal[2], plane->dist);
#endif
#ifdef HLRAD_POINT_IN_EDGE_FIX
            if (point_in_winding_percentage(*winding, *plane, point, direction, percentage))
#else
            if (point_in_winding(*winding, *plane, point))
#endif
            {
#if 0
                Log("Ray from (%4.3f %4.3f %4.3f) to (%4.3f %4.3f %4.3f) blocked by face %u @ (%4.3f %4.3f %4.3f)\n",
                    p1[0], p1[1], p1[2],
                    p2[0], p2[1], p2[2], g_opaque_face_list[x].facenum, point[0], point[1], point[2]);
#endif

#ifdef HLRAD_HULLU
		        if(g_opaque_face_list[x].transparency)
		        {
#ifdef HLRAD_TestSegmentAgainstOpaqueList_VL
					VectorCopy (g_opaque_face_list[x].transparency_scale, scale_one);
#endif
	#ifdef HLRAD_POINT_IN_EDGE_FIX
					if (percentage != 1.0)
						for (i = 0; i < 3; ++i)
							scale_one[i] = pow (scale_one[i], percentage);
	#endif
#ifdef HLRAD_TestSegmentAgainstOpaqueList_VL
			        VectorMultiply(scale, scale_one, scale);
#else
			        VectorMultiply(scale, g_opaque_face_list[x].transparency_scale, scale);
#endif
		        }
                else
                {
#ifdef HLRAD_OPAQUE_STYLE
					if (g_opaque_face_list[x].style == -1 || opaquestyleout != -1 && g_opaque_face_list[x].style != opaquestyleout)
					{
						VectorCopy(vec3_origin, scaleout);
						opaquestyleout = -1;
			        	return true;
					}
					else
					{
						opaquestyleout = g_opaque_face_list[x].style;
					}
#else
	#ifdef HLRAD_TestSegmentAgainstOpaqueList_VL
					VectorCopy(vec3_origin, scaleout);
	#else
                    VectorCopy(scale, scaleout);
	#endif
                	return true;
#endif
                }
#else
                return true;
#endif
            }
        }
    }

#ifdef HLRAD_HULLU
    VectorCopy(scale, scaleout);
    if(scaleout[0] < 0.01 && scaleout[1] < 0.01 && scaleout[2] < 0.01)
    {
    	return true; //so much shadowing that result is same as with normal opaque face
    }
#endif

    return false;
#endif /*HLRAD_OPAQUE_NODE*/
}

#ifndef HLRAD_MATH_VL
// =====================================================================================
//  ProjectionPoint
// =====================================================================================
void            ProjectionPoint(const vec_t* const v, const vec_t* const p, vec_t* rval)
{
    vec_t           val;
    vec_t           mag;

    mag = DotProduct(p, p);
#ifdef SYSTEM_POSIX
    if (mag == 0)
    {
        // division by zero seems to work just fine on x86;
        // it returns nan and the program still works!!
        // this causes a floating point exception on Alphas, so...
        mag = 0.00000001; 
    }
#endif
    val = DotProduct(v, p) / mag;

    VectorScale(p, val, rval);
}
#endif

// =====================================================================================
//  SnapToPlane
// =====================================================================================
void            SnapToPlane(const dplane_t* const plane, vec_t* const point, vec_t offset)
{
#ifdef HLRAD_MATH_VL
	vec_t			dist;
	dist = DotProduct (point, plane->normal) - plane->dist;
	dist -= offset;
	VectorMA (point, -dist, plane->normal, point);
#else
    vec3_t          delta;
    vec3_t          proj;
    vec3_t          pop;                                   // point on plane

    VectorScale(plane->normal, plane->dist + offset, pop);
    VectorSubtract(point, pop, delta);
    ProjectionPoint(delta, plane->normal, proj);
    VectorSubtract(delta, proj, delta);
    VectorAdd(delta, pop, point);
#endif
}
#ifdef HLRAD_ACCURATEBOUNCE
// =====================================================================================
//  CalcSightArea
// =====================================================================================
vec_t CalcSightArea (const vec3_t receiver_origin, const vec3_t receiver_normal, const Winding *emitter_winding, int skylevel)
{
	// maybe there are faster ways in calculating the weighted area, but at least this way is not bad.
	vec_t area = 0.0;

	int numedges = emitter_winding->m_NumPoints;
	vec3_t *edges = (vec3_t *)malloc (numedges * sizeof (vec3_t));
	hlassume (edges != NULL, assume_NoMemory);
	bool error = false;
	for (int x = 0; x < numedges; x++)
	{
		vec3_t v1, v2, normal;
		VectorSubtract (emitter_winding->m_Points[x], receiver_origin, v1);
		VectorSubtract (emitter_winding->m_Points[(x + 1) % numedges], receiver_origin, v2);
		CrossProduct (v1, v2, normal); // pointing inward
		if (!VectorNormalize (normal))
		{
			error = true;
		}
		VectorCopy (normal, edges[x]);
	}
	if (!error)
	{
		int i, j;
		vec3_t *pnormal;
		vec_t *psize;
		vec_t dot;
		vec3_t *pedge;
		for (i = 0, pnormal = g_skynormals[skylevel], psize = g_skynormalsizes[skylevel]; i < g_numskynormals[skylevel]; i++, pnormal++, psize++)
		{
			dot = DotProduct (*pnormal, receiver_normal);
			if (dot <= 0)
				continue;
			for (j = 0, pedge = edges; j < numedges; j++, pedge++)
			{
				if (DotProduct (*pnormal, *pedge) <= 0)
				{
					break;
				}
			}
			if (j < numedges)
			{
				continue;
			}
			area += dot * (*psize);
		}
		area = area * 4 * Q_PI; // convert to absolute sphere area
	}
	free (edges);
	return area;
}

#ifdef HLRAD_CUSTOMTEXLIGHT
vec_t CalcSightArea_SpotLight (const vec3_t receiver_origin, const vec3_t receiver_normal, const Winding *emitter_winding, const vec3_t emitter_normal, vec_t emitter_stopdot, vec_t emitter_stopdot2, int skylevel)
{
	// stopdot = cos (cone)
	// stopdot2 = cos (cone2)
	// stopdot >= stopdot2 >= 0
	// ratio = 1.0 , when dot2 >= stopdot
	// ratio = (dot - stopdot2) / (stopdot - stopdot2) , when stopdot > dot2 > stopdot2
	// ratio = 0.0 , when stopdot2 >= dot2
	vec_t area = 0.0;

	int numedges = emitter_winding->m_NumPoints;
	vec3_t *edges = (vec3_t *)malloc (numedges * sizeof (vec3_t));
	hlassume (edges != NULL, assume_NoMemory);
	bool error = false;
	for (int x = 0; x < numedges; x++)
	{
		vec3_t v1, v2, normal;
		VectorSubtract (emitter_winding->m_Points[x], receiver_origin, v1);
		VectorSubtract (emitter_winding->m_Points[(x + 1) % numedges], receiver_origin, v2);
		CrossProduct (v1, v2, normal); // pointing inward
		if (!VectorNormalize (normal))
		{
			error = true;
		}
		VectorCopy (normal, edges[x]);
	}
	if (!error)
	{
		int i, j;
		vec3_t *pnormal;
		vec_t *psize;
		vec_t dot;
		vec_t dot2;
		vec3_t *pedge;
		for (i = 0, pnormal = g_skynormals[skylevel], psize = g_skynormalsizes[skylevel]; i < g_numskynormals[skylevel]; i++, pnormal++, psize++)
		{
			dot = DotProduct (*pnormal, receiver_normal);
			if (dot <= 0)
				continue;
			for (j = 0, pedge = edges; j < numedges; j++, pedge++)
			{
				if (DotProduct (*pnormal, *pedge) <= 0)
				{
					break;
				}
			}
			if (j < numedges)
			{
				continue;
			}
			dot2 = -DotProduct (*pnormal, emitter_normal);
			if (dot2 <= emitter_stopdot2 + NORMAL_EPSILON)
			{
				dot = 0;
			}
			else if (dot2 < emitter_stopdot)
			{
				dot = dot * (dot2 - emitter_stopdot2) / (emitter_stopdot - emitter_stopdot2);
			}
			area += dot * (*psize);
		}
		area = area * 4 * Q_PI; // convert to absolute sphere area
	}
	free (edges);
	return area;
}

#endif
#endif
#ifdef HLRAD_ACCURATEBOUNCE_ALTERNATEORIGIN
// =====================================================================================
//  GetAlternateOrigin
// =====================================================================================
void GetAlternateOrigin (const vec3_t pos, const vec3_t normal, const patch_t *patch, vec3_t &origin)
{
	const dplane_t *faceplane;
	const vec_t *faceplaneoffset;
	const vec_t *facenormal;
	dplane_t clipplane;
	Winding w;

	faceplane = getPlaneFromFaceNumber (patch->faceNumber);
	faceplaneoffset = g_face_offset[patch->faceNumber];
	facenormal = faceplane->normal;
	VectorCopy (normal, clipplane.normal);
	clipplane.dist = DotProduct (pos, clipplane.normal);
	
	w = *patch->winding;
	if (w.WindingOnPlaneSide (clipplane.normal, clipplane.dist) != SIDE_CROSS)
	{
		VectorCopy (patch->origin, origin);
	}
	else
	{
		w.Clip (clipplane, false);
		if (w.m_NumPoints == 0)
		{
			VectorCopy (patch->origin, origin);
		}
		else
		{
			vec3_t center;
			bool found;
			vec3_t bestpoint;
			vec_t bestdist = -1.0;
			vec3_t point;
			vec_t dist;
			vec3_t v;

			w.getCenter (center);
			found = false;

			VectorMA (center, PATCH_HUNT_OFFSET, facenormal, point);
			if (HuntForWorld (point, faceplaneoffset, faceplane, 2, 1.0, PATCH_HUNT_OFFSET))
			{
				VectorSubtract (point, center, v);
				dist = VectorLength (v);
				if (!found || dist < bestdist)
				{
					found = true;
					VectorCopy (point, bestpoint);
					bestdist = dist;
				}
			}
			if (!found)
			{
				for (int i = 0; i < w.m_NumPoints; i++)
				{
					const vec_t *p1;
					const vec_t *p2;
					p1 = w.m_Points[i];
					p2 = w.m_Points[(i + 1) % w.m_NumPoints];
					VectorAdd (p1, p2, point);
					VectorAdd (point, center, point);
					VectorScale (point, 1.0/3.0, point);
					VectorMA (point, PATCH_HUNT_OFFSET, facenormal, point);
					if (HuntForWorld (point, faceplaneoffset, faceplane, 1, 0.0, PATCH_HUNT_OFFSET))
					{
						VectorSubtract (point, center, v);
						dist = VectorLength (v);
						if (!found || dist < bestdist)
						{
							found = true;
							VectorCopy (point, bestpoint);
							bestdist = dist;
						}
					}
				}
			}

			if (found)
			{
				VectorCopy (bestpoint, origin);
			}
			else
			{
				VectorCopy (patch->origin, origin);
			}
		}
	}
}

#endif
